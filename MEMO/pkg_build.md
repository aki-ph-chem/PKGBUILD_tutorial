# PKGBUILDのメモ

以下には、makepkgとPKGBUILDの要点について述べる。

PKGBUILDに含まれる変数等についての詳細は[PKGBUILDの記事](https://wiki.archlinux.jp/index.php/PKGBUILD)を参照

## パッケージングプロセス

Arc Linuxにおけるパッケージングは<b>makepkg</b>コマンドを
<b>PKGBUILD</b>が存在するディレクトリで実行することによって行うことができる。
このとき以下のプロセスが進行し最終的にパッケージファイル\*pkg.tar.zstが生成される。

1. 依存パッケージがインストールされているかを確認する。 
2. ソースをサーバーからダウンロードする
3. 圧縮されたソースファイルを展開する。
4. fakeroot環境でコンパイル、インストールを行う 5. バイナリやライブラリから不要なシンボルを除去する。(symbol stripping)
6. パッケージのメタデータを生成する。
7. fakeroot環境をパッケージに圧縮する
8. パッケージファイル(\*.pkg.tar.zst)を出力ディレクトリに保存する。デフォルトでは作業ディレクトリ

## PKGBUILDの変数

PKGBUILDには多くの変数があるが、特に重要なものをは<b>srcdir</b>, <b>pkgdir</b>である。

- <b>srcdir</b>
   - <b>makepkg</b>がソースファイルを展開またはコピーしてくるディレクトリ 
- <b>pkgdir</b>
   - build()が終わった後で<b>makepkg</b>はここに生成されたファイルをパッケージに入れる。
すなわちここがパッケージのrootとなる

## PKGBUILDの関数

以下ではPKGBUILDの関数について解説する。
PKGBUILDで定義されている関数にはprepare(),pkgver(),build(),package(),check()がある。

- build(),package()は対話的になるようになってはならない。
- package()は必須の関数で、省略することはできない。

- <b>prepare()</b>: pacman 4.1から導入された
    - パッチなどのソースコードをビルドする前の準備段階で実行されるコマンドの実行を行う。
    - build()の前,パッケージの展開の後で実行される
    - makepkg -eと展開を省略した場合では実行されない。

- <b>pkgver()</b>: pacman 4.1から
    - makepkgの実行中にpkgverの変数を更新することができる。 
    - ソースが取得・展開された後すぐに実行される。
    - git/svn/hgなどのパッケージを作成するときに便利

- <b>build()</b>
    - Bashの文法に基づいてソースコードから目的のバイナリをビルドするために用いられる。
    - 多くの場合まずsrcdirへの移動からスタートする

```bash
cd "${srcdir}/$pkgname-$pkgdir"
```
-  
    - ビルドが完了するとpkgディレクトリが作成されて、目的のバイナリはここにインストールされる
    - ビルドのコマンド群は手動でビルドする場合と同じものを用いる
    - 例えば、cofigureを用いているならば--prefix=/usr
    - インストール先は/usr下にするべきである。/usr/localは手動の場合にのみ用いられるべきである。
    - ビルドする必要のないパッケージの場合(ex. all pythonのアプリ)はbuild()関数は仕様するべきでない。

```bash
./configure --prefix=/usr
make
```

- <b>check()</b>
    - ビルドされたソフトウェアのの確認や依存関係が問題ないかをテスト。
    - `PKGBUILD`や`makepkg.conf`で`BUILDENV+=('!check')`オプションを指定する。
    - もしくは`--nocheck`フラッグを用いてmakepkgを呼び出す

- <b>package()</b>
    - 最後にビルドされたファイルをmakepkgが読み込む。
    - デフォルトは`pkg`ディレクトリでこれはfakeroot環境である。 
    - すなわち、このディレクトリがインストール先のroot(/)となる。
    - インストールしたいファイルは`pkg`以下にディレクトリ構造を保ったまま配置される必要がある。
    - 例えば、/usr/bin以下にインストールしたいならば(以下の例ではインストール先は全て/usr/binとする)${pkgdir}/usr/binにファイルを置くようにする
    - 多くの場合この処理は`make install`によって実行される

```bash
make DESTDIR="$pkgdir/usr/bin" install
```

-
    - 基本的には`make DESTDIR="$pkgdir/usr/bin"`で書くこと。
    - `DESTDIR`が使えない場合は`make --prefix="$pkgdir/usr/bin" install`で書く
    - ソースコードの再コンパイルを行いたくない(build()を呼び出したくない)場合では`make --replace`を実行する
    - この場合では`pakcage()`のみが呼び出される。


## テスト

### 基本的なパッケージのチェック

PKGBUILDを書いてパッケージを作成する段階におけるミスは`makepkg`コマンドを実行すればPKBBUILDの内容をチェックされる。
もし、不具合があればエラーを吐き停止する。
`makepkg`が正常に終了したならば、作業ディレクトリ中に`pkgname-pkgver.pkg.tar.zst`というファイルが生成される。
このパッケージは`pacman -U `でインストールが可能である。

生成されたパッケージ必ずしも正常に機能するとは限らない。
機能しない例としてはprefixが間違って設定されていることが挙がられる。
pacmanのquery関数を使うことでパッケージに含まれているファイルのリスト、
依存パッケージは`pacman -Qlp <package file name>`, `pacman -Qlp <package file name> `で表示することができる。

### namcapを使った正常性のチェック

パッケージが正常に機能するかのテストをパスしたならば`namcap`コマンドを用いたエラーチェックを
行うべきである。

```bash
$ namcap PKGBUILD
$ namcap <package file name>.pkg.tar.zst
```

この`namcap`は以下のチェックをパッケージに対して行う。

1. PKGBUILDの中身を見て、よくある間違いやパッケージファイルの改装に不必要な・間違って置かれたファイルがないか確認する。 
2. `ldd`を使ってパッケージ内の全てのELFファイルをスキャンして必要な共有ライブラリがあるパッケージが`depends`に欠けていることや推移的にな依存として省略できるパッケージを自動で報告する 
3. 欠けている、もしくは不必要な依存パッケージのヒューリスティックな検索。
