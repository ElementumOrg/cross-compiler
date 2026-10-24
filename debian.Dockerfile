ARG BASE_IMAGE=debian:bullseye
FROM ${BASE_IMAGE}

# shortcut: bullseye is EOL and only on archive.debian.org; move to bookworm to drop this
RUN sed -i 's#http://deb.debian.org#http://archive.debian.org#' /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https gnupg ca-certificates \
    curl wget \
    pkg-config build-essential make automake autogen libtool \
    libpcre2-dev libpcre3-dev bison yodl \
    tar xz-utils bzip2 gzip unzip \
    git \
    file \
    rsync \
    upx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
