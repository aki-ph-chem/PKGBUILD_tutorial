## Rustのプロジェクトからパッケージを作成する

基本的にはC言語のソースツリーからビルドする場合と変わらず`build()`によってソースコードからビルドし、
`package()`によってパッケージングを行う。

以下では、各関数における処理について説明する。

### `build()`

Cのプロジェクトでは、`${crcdir}/$pkgname-$pkgver`に移動して`make`によってプロジェクトをビルドしている。

Rustでは、`make`ではなくて`cargo build`によってビルドを行う。

```bash
build() {
	cd "${srcdir}/$pkgname-$pkgver"
        cargo build --release --locked
}
```

ここで、`--release`はリリースビルドでコンパイルを行うオプションで
`--locked`は`Cargo.lock`ファイルを変更して依存関係を更新しなくするためのオプションである。

### `package()`

Cのプロジェクトで行っていた通りに、`${srcdir}/$pkgname-$pkgver`に移動して、バイナリを移動する処理を書く。
ビルドされたバイナリは`target/release/${pkgname}`であるのでこれを`pkgdir/usr/bin/`にインストールする。

```bash
package() {
    cd "${srcdir}/$pkgname-$pkgver"
    install -Dm755 "target/release/$pkgname" -t "$pkgdir/usr/bin/"
}
```
