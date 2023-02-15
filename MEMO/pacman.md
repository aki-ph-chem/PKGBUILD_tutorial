# pacman

- 参考
    - [archwiki: pacman](https://wiki.archlinux.jp/index.php/Pacman)

- pacmanは\*.pkg.tar.zstパッケージフォーマットを用いる。

- \*.pkg.tar.zstの構造: 以下のようにファイル群が格納されている
    - .PKGINFO: pacmanでパッケージ管理、依存解決をするために必要な情報
    - .BUILDINFO: Reproducible Buildsのための情報
    - .MTREE: ファイルのハッシュとタイムスタンプ
    - .INSTALL: インストール/アップデート/削除の後で実行されるスクリプト(PKGBUILDで指定された場合のみ存在する)
    - .Changelog: パッケージメンテなによるパッケージの更新についての覚え書き(必ず存在するとは限らない)

```
.BUILDINFO
.MTREE
.PKGINFO
バイナリ
```

- 設定
    - /etc/pacman.confに書き込む

- インストールされたパッケージの情報
    - インストールされたパッケージの情報すなわちデータベースは/var/lib/pacman/syncに置かれていてgzip形式で圧縮されている(\*.tar.gz)。
