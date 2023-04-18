#!/usr/bin/bash

pkgname="greet"
pkgver=1.0

src="greet"
tarball_name="${pkgname}-${pkgver}"

if [ ! -e ${tarball_name} ]; then
    cp -r ../${src} ${tarball_name}
fi

if [ ! -e ${tarball_name}.tar.gz ]; then 
    tar -cvzf ${tarball_name}.tar.gz ${tarball_name}
fi

makepkg -g >> PKGBUILD
makepkg -s
