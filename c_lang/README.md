## C言語のソースコードからなるパッケージ

ここではごくごく簡単なCLIアプリケーションとしてコマンドライン引数に渡した文字列を加工して
標準出力に出力するgreetプログラムを例とする。
ソースコードは以下のようになる。

main.c
```C
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv) { if(argc < 2) {
        fprintf(stderr, "Error: No args\n");
        exit(1);
    }

    char* name = argv[1];
    printf("Hello %s! \n",name);
}
```

このソースをビルドするためのMakefileは以下のものを用意する。

```Makefile
CC = gcc
DESTDIR=''

greet : main.c
	${CC} -o $@ $<

clean:
	rm greet

install:
	install -s ./greet ${DESTDIR}/ 

.PHONY: clean
```

このソースコードとMakefileをmy_greet-1.0としたディレクトリに格納する。ここで前半のmy_greetはパッケージ名で、後半の1.0はバージョンである。

このとき、ディレクトリ構造は以下のようになっている。
```
.
└── my_greet-1.0
    ├── main.c
    └── Makefile
```

これをmy_greet-1.0.tar.gzに固める

```bash
$ tar -cvzf my_greet-1.0.tar.gz my_greet-1.0 
```

ここにBKGBUILDを置く。BKGBUILDのテンプレートは/usr/share/pacman下にあるのでこれをコピーして使う。

```bash
$ cp /usr/share/pacman/PKBBUILD.proto .
```

この時点でのディレクトリ構造は以下のようになっている

```
.
├── my_greet-1.0.tar.gz
└── PKGBUILD
```

以下ではいよいよPKGBUILDを書いていく。
まず、いきなり以下に実際に書いたPKBBUILDを示し、細かな変数について説明する。

```bash
pkgname=my_greet
pkgver=1.0
pkgrel=1
epoch=
pkgdesc="my_greet is example package for tutorial"
arch=('x86_64')
url=""
license=('MIT')
groups=()
depends=()
makedepends=()
checkdepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=("$pkgname-$pkgver.tar.gz")
noextract=()
md5sums=()
validpgpkeys=()

build() {
	cd "${srcdir}/$pkgname-$pkgver"
	make
}


package() {
	cd "${srcdir}/$pkgname-$pkgver"
        make DESTDIR=${pkgdir} install
        install -Dm755 ${pkgdir}/greet -t ${pkgdir}/usr/bin
}
```
細々とした変数には以下のようなものがある。


- pkgname: パッケージの名前 
- pkgver: パッケージのバージョン
- pkgrel: パッケージのリリース
- pkgdesc: パッケージの簡単な説明
- arch: アーキテクチャ
- license: ライセンス
- depends: 依存パッケージ
- install: installするときに実行するスクリプトを登録することができるz。
- source: 前述したpkgname,pkgverを展開して\*.tar.gzに固めたソースコード群の名前を記述すzる

- build(): ソースコードをビルドする際に実行される関数
- package(): ビルドされたパッケージをパッケージングする際に実行される関数。この関数は省くことはできない。


完成したPKBBUILDのあるディレクトリで以下のコマンドを実行することでパッケージを生成できる。

```bash
$ makepkg -g >> PKGBUILD
$ makepkg -s
```

このコマンド操作によりパッケージmy_greet-1.0-1-x86_64.pkg.tar.zstが生成される。
これをpacmanコマンドでinstallを実行することでパッケージをインストールできる。

```bash
$ sudo pacman -U my_greet-1.0-1-x86_64.pkg.tar.zst
```
