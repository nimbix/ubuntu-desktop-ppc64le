#!/bin/bash

ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=$PWD/tigervnc_build
TIGERVNC_SOURCE=$PWD/tigervnc

cd /tmp
curl https://www.x.org/archive/individual/xserver/xorg-server-1.18.0.tar.bz2|tar xjf -

git clone https://github.com/TigerVNC/tigervnc.git
cd $TIGERVNC_SOURCE
git checkout "1.7-branch"

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr $TIGERVNC_SOURCE
make 

# Build Xvnc
cp -R $TIGERVNC_SOURCE/unix/xserver $BUILD_DIR/unix/
cp -R /tmp/xorg-server*/* $BUILD_DIR/unix/xserver/
rm -rf /tmp/xorg-server*
cd $BUILD_DIR/unix/xserver
patch -p1 < "$TIGERVNC_SOURCE/unix/xserver118.patch"
autoreconf -fiv
./configure --prefix=$BUILD_DIR/xorg.build --with-pic --without-dtrace --disable-static --disable-dri \
  --disable-xinerama --disable-xvfb --disable-xnest --disable-xorg \
  --disable-dmx --disable-xwin --disable-xephyr --disable-kdrive \
  --disable-config-dbus --disable-config-hal --disable-config-udev \
  --disable-dri2 --enable-install-libxf86config --enable-glx \
  --with-fontdir=/usr/share/fonts/X11 \
  --with-xkb-path=/usr/share/X11/xkb \
  --with-xkb-output=/var/lib/xkb \
  --with-xkb-bin-directory=/usr/bin \
  --with-serverconfig-path=/usr/lib/xorg \
  --with-dri-driver-path=/usr/lib/powerpc64le-linux-gnu/dri 

make TIGERVNC_SRCDIR=$TIGERVNC_SOURCE install

cd $BUILD_DIR
cp -r /usr/lib/powerpc64le-linux-gnu/dri $BUILD_DIR/xorg.build/lib
mkdir -p "$BUILD_DIR/xorg.build/man/man1"
ln -s "$BUILD_DIR/xorg.build/share/man/man1/Xvnc.1" "$BUILD_DIR/xorg.build/man/man1"
ln -s "$BUILD_DIR/xorg.build/share/man/man1/Xserver.1" "$BUILD_DIR/xorg.build/man/man1"
make servertarball

chmod 664 $BUILD_DIR/tigervnc-Linux*.tar.gz
cp $BUILD_DIR/tigervnc-Linux*.tar.gz /root

rm -rf $BUILD_DIR $TIGERVNC_SOURCE
