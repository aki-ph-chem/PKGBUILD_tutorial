## バイナリパッケージ

ここでは回転分光ので良く用いられているプログラムである
[pgopher](http://pgopher.chm.bris.ac.uk/Help/main.htm)
を例にコンパイル済みのバイナリからパッケージを作成する方法を解説する。
ソースとしてはtarballとして`pgopher_gnu_linux-beta.tar.gz`を用いる。

このtarballからパッケージを作成するために以下のようにPKGBUILDを書く。

```bash
# This is an example PKGBUILD file. Use this as a start to creating your own,
# and remove these comments. For more information, see 'man PKGBUILD'.
# NOTE: Please fill out the license field for your package! If it is unknown,
# then please put 'unknown'.

# Maintainer: Your Name <youremail@domain.com>
pkgname=pgopher_gnu_linux
pkgver=beta
pkgrel=1
epoch=
pkgdesc="pgopher"
arch=('x86_64')
url=""
license=('LGPL')
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

package() {
    install -Dm755 ${srcdir}/pgopher -t ${pkgdir}/usr/bin
    install -Dm755 ${srcdir}/pgo -t ${pkgdir}/usr/bin
    install -Dm755 ${srcdir}/tabslave -t ${pkgdir}/usr/bin
}
```

現在の作業ディレクトリは以下のようになっている

```
pgopher
├── pgopher_gnu_linux-beta.tar.gz
└── PKGBUILD
```

この作業ディレクトリで以下のように`makepkg`コマンドを実行することで
パッケージをビルドする

```bash
$ makepkg -g >> PKGBUILD
$ makepkg -s
```

上では、ローカルにダウンロードしたtarballからパッケージを生成するPKGBUILDを示したが、
以下では配布サイトからダウンロードしてパッケージを生成するPKGBUILDを示す。

```bash
# This is an example PKGBUILD file. Use this as a start to creating your own,
# and remove these comments. For more information, see 'man PKGBUILD'.
# NOTE: Please fill out the license field for your package! If it is unknown,
# then please put 'unknown'.

# Maintainer: Your Name <youremail@domain.com>
pkgname=pgopher
pkgver=gtk2
pkgrel=1
epoch=
pkgdesc="pgopher"
arch=('x86_64')
url=""
license=('LGPL')
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
source=("http://pgopher.chm.bris.ac.uk/download/$pkgname-$arch-linux-$pkgver.tgz")
noextract=()
md5sums=()
validpgpkeys=()

package() {
    install -Dm755 ${srcdir}/pgopher -t ${pkgdir}/usr/bin
    install -Dm755 ${srcdir}/pgo -t ${pkgdir}/usr/bin
    install -Dm755 ${srcdir}/tabslave -t ${pkgdir}/usr/bin
}

sha256sums=('SKIP')
```
