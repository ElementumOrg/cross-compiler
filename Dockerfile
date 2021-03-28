FROM debian:buster

RUN apt-get update && apt-get -y -f install \
    bash \
    curl wget \
    pkg-config build-essential make automake autogen libtool cmake \
    libpcre3-dev bison yodl \
    tar xz-utils bzip2 gzip unzip \
    file \
    rsync \
    sed \
    upx
