#!/bin/bash

git clone -b master https://github.com/agherzan/meta-raspberrypi.git
git clone -b master https://github.com/meta-qt5/meta-qt5.git
git clone -b master https://github.com/openembedded/meta-openembedded.git
git clone -b master https://github.com/openembedded/openembedded-core.git

source oe-init-build-env # in build dir

bitbake-layers add-layer ../meta-raspberrypi
bitbake-layers add-layer ../meta-seeed-reterminal
bitbake-layers add-layer ../meta-qt5
bitbake-layers add-layer ../meta-openembedded/meta-oe
bitbake-layers add-layer ../meta-openembedded/meta-python

# modify local.conf to build raspberrypi4 64-bit system
sed -i '/^MACHINE/s/= .*$/= "raspberrypi4-64"/g' conf/local.conf
sed -i '/^DL_DIR/s/= .*$/= "/home/xiongjian/cache/yocto_cache/share/downloads"/g' conf/local.conf
sed -i '$aRPI_KERNEL_DEVICETREE_OVERLAYS_append = \" overlays/reTerminal.dtbo\"' conf/local.conf
sed -i '$aPACKAGECONFIG_append_pn-qtbase = \" eglfs \"' conf/local.conf
sed -i '$aSSTATE_DIR ?= "/home/xiongjian/compile/build_cache/sstate-cache"' conf/local.conf

# building image
bitbake rpi-basic-image
