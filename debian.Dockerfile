FROM debian:stretch

RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list

ARG CMAKE_VERSION=3.20.3

RUN apt-get update && apt-get -y -f install \
    bash \
    curl wget \
    pkg-config build-essential make automake autogen libtool \
    libpcre2-dev libpcre3-dev bison yodl \
    tar xz-utils bzip2 gzip unzip \
    file \
    rsync \
    sed \
    upx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz" \
    --no-check-certificate -qO- | tar --strip-components=1 -xz --one-top-level=/usr
