FROM elementumorg/cross-compiler:base

RUN apt-get update && \ 
    apt-get -y install --no-install-recommends \
    crossbuild-essential-armhf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CROSS_TRIPLE="armv7-linux-gnueabihf"
ENV CROSS_ROOT="/usr/${CROSS_TRIPLE}"
ENV PATH="${PATH}:${CROSS_ROOT}/bin:${CROSS_ROOT}/go/bin"
ENV LD_LIBRARY_PATH="${CROSS_ROOT}/lib"
ENV PKG_CONFIG_PATH="${CROSS_ROOT}/lib/pkgconfig"

RUN cd /usr/bin && \
    ln -s arm-linux-gnueabihf-ar ${CROSS_TRIPLE}-ar && \
    ln -s arm-linux-gnueabihf-gcc-10 ${CROSS_TRIPLE}-cc && \
    ln -s arm-linux-gnueabihf-gcc-10 ${CROSS_TRIPLE}-gcc && \
    ln -s arm-linux-gnueabihf-g++-10 ${CROSS_TRIPLE}-g++ && \
    ln -s arm-linux-gnueabihf-g++-10 ${CROSS_TRIPLE}-c++ && \
    ln -s arm-linux-gnueabihf-strip ${CROSS_TRIPLE}-strip && \
    ln -s arm-linux-gnueabihf-ranlib ${CROSS_TRIPLE}-ranlib
