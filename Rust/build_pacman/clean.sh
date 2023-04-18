#!/usr/bin/bash

pkgname="greet"
pkgver=1.0
arch="any"

src="greet"
tarball_name="${pkgname}-${pkgver}"
target_array=("pkg" "src" "${tarball_name}" "${tarball_name}.tar.gz" "${tarball_name}-1-${arch}.pkg.tar.zst")

for i in "${target_array[@]}"; do
    if [ -e $i ]; then
        rm -rf $i
    fi
done
