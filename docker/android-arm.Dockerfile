FROM elementumorg/cross-compiler:base

ENV CROSS_TRIPLE="arm-linux-androideabi"
ENV CROSS_ROOT="/usr/${CROSS_TRIPLE}"
ENV PATH="${PATH}:${CROSS_ROOT}/bin:${CROSS_ROOT}/go/bin"
ENV LD_LIBRARY_PATH="${CROSS_ROOT}/lib"
ENV PKG_CONFIG_PATH="${CROSS_ROOT}/lib/pkgconfig"
ENV NDK="android-ndk-r20b"

RUN apt-get update && apt-get install -y --no-install-recommends \
    python \
    zlib1g-dev \
    libcurl4-openssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex && \
    mkdir -p /build && \
    cd /build && \
    wget -nv https://dl.google.com/android/repository/${NDK}-linux-x86_64.zip && \
    unzip ${NDK}-linux-x86_64.zip 1>log 2>err && \
    cd ${NDK} && \
    ./build/tools/make_standalone_toolchain.py --arch=arm --api=21 --install-dir=${CROSS_ROOT} && \
    find ${CROSS_ROOT} ${CROSS_ROOT}/sysroot/usr/lib -mindepth 1 -maxdepth 1 -type d -name '*-linux-android*' ! -name ${CROSS_TRIPLE} -exec rm -rf {} + && \
    cd / && rm -rf /build

RUN cd ${CROSS_ROOT}/bin && \
    ln -s ${CROSS_TRIPLE}-clang ${CROSS_TRIPLE}-cc
