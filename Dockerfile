FROM nvidia/cuda-ppc64le:8.0-cudnn6-devel-ubuntu16.04

# nimbix account and desktop setup
RUN apt-get update && apt-get -y install curl && apt-get clean
RUN curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh | bash -s -- --setup-nimbix-desktop
EXPOSE 22
EXPOSE 5901
EXPOSE 443

