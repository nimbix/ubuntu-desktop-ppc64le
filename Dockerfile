FROM nvidia/cuda-ppc64le:8.0-cudnn6-devel-ubuntu16.04

RUN apt-get update && apt-get install -y sudo build-essential curl git cmake libx11-dev zlib1g-dev libjpeg-turbo8-dev gettext libfltk1.3-dev libxrender-dev autoconf automake autopoint libtool pkg-config bison flex gperf m4 libncurses5-dev intltool llvm libtalloc-dev libgbm1 libmtdev-dev libgcrypt20-dev libssl-dev libmd-dev fontconfig libpng-dev libfreetype6-dev xutils-dev xfonts-utils xserver-xorg-dev libxfont1-dev libpixman-1-dev x11proto-record-dev x11proto-xcmisc-dev x11proto-bigreqs-dev x11proto-composite-dev asciidoc doxygen xmlto xsltproc libevdev-dev && apt-get clean

# Build TigerVNC
COPY build-tigervnc.sh /tmp/build-tigervnc.sh
RUN /tmp/build-tigervnc.sh

# nimbix account setup
RUN apt-get update && apt-get -y install curl && apt-get clean
RUN curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh | bash
EXPOSE 22

