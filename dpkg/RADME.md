# 番外編: Rustからdpkg(Debian系向けのパッケージ)を作成する

一番簡単な方法は`cargo deb`を使う方法である。
単一バイナリを`/usr/bin`に置くくらいシンプルなケースでは十分だが、そうでない場合ではダメらしい...

今回は簡単な例なので`cargo deb`を使って作成する方法を選ぶ

## 準備

Cargo.tomlの以下の内容が未記入であるとビルドができない。


- authors: 開発者名

例)
```
authors = ["Aki <my_mail@aki.com>"]
```

- license: MIT,GPL等のライセンスを書く

例)
```
license = "MIT"
```

- description: パッケージに対する簡単な説明

例)
```
description = "simple & small CLI application for sample of dpkg package"
```

## いざビルド

プロジェクトのルートすなわち`Cargo.toml`のあるディレクトリでビルドコマンド

```bash
$ cargo deb
```

を実行する。

ビルドに成功すると`target/debian/`に\*.debファイルが生成されているはず。
なのでこれを`dpkg`コマンドでインストールする

```bash
$ dpkg -i target/debian/*.deb
```

(`apt install`ではインストールできなかった)

## 環境構築について

ここでは`Docker`でDebianの環境構築し、そこでビルドを行う。
(Arch Linux x86-64でビルドしてdebianに持って行って実行したら共有ライブラリの関係で実行できなかった(インストールはできた))

[config](./config)に`Dockerfile`と環境構築用のシェルスクリプト`init.sh`用意しておいた

### 具体的にどうするか?

まず、ホストマシンのプロジェクトのルートをコンテナからマントした状態で起動する。

```bash
$ docker run --rm -it -v `pwd`/<project name>:/root/<project name> cargo_deb:v1
```

なおイメージ名は以下手順で`cargo_deb`としてビルドしたものとする

Dockerfileとinit.shのあるディレクトリで以下のコマンドを実行
```bash
$ docker build ./ -t cargo_deb:v1
```

コンテナが起動するとプロンプトが`#`となる(rootユーザーのため)
ここで`~`すなわち`/root`に移動する

```bash
# cd ~
```

ここに`init.sh`があるのでこれを実行する

```bash
# cat init.sh | sh
```

これで、必要なツールが揃う

これだけではCargo等のパスが通っていないので

```bash
# source ~/.bashrc
```

としてパスを通す
