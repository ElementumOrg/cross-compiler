FROM elementumorg/cross-compiler:base

RUN apt-get update && apt-get -y install crossbuild-essential-arm64

ENV CROSS_TRIPLE="aarch64-linux-gnu"
ENV CROSS_ROOT="/usr/${CROSS_TRIPLE}"
ENV PATH="${PATH}:${CROSS_ROOT}/bin:${CROSS_ROOT}/go/bin"
ENV LD_LIBRARY_PATH="${CROSS_ROOT}/lib"
ENV PKG_CONFIG_PATH="${CROSS_ROOT}/lib/pkgconfig"

RUN cd /usr/bin && \
    ln -s aarch64-linux-gnu-gcc-10 ${CROSS_TRIPLE}-cc && \
    ln -s aarch64-linux-gnu-g++-10 ${CROSS_TRIPLE}-c++
