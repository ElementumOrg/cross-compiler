FROM elementumorg/cross-compiler:base

RUN apt-get update && \ 
    apt-get -y install --no-install-recommends \
    crossbuild-essential-armel \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CROSS_TRIPLE="armv7-linux-gnueabi"
ENV CROSS_ROOT="/usr/${CROSS_TRIPLE}"
ENV PATH="${PATH}:${CROSS_ROOT}/bin:${CROSS_ROOT}/go/bin"
ENV LD_LIBRARY_PATH="${CROSS_ROOT}/lib:${LD_LIBRARY_PATH}"
ENV PKG_CONFIG_PATH="${CROSS_ROOT}/lib/pkgconfig:${PKG_CONFIG_PATH}"

RUN cd /usr/bin && \
    ln -s arm-linux-gnueabi-ar ${CROSS_TRIPLE}-ar && \
    ln -s arm-linux-gnueabi-gcc-10 ${CROSS_TRIPLE}-cc && \
    ln -s arm-linux-gnueabi-gcc-10 ${CROSS_TRIPLE}-gcc && \
    ln -s arm-linux-gnueabi-g++-10 ${CROSS_TRIPLE}-g++ && \
    ln -s arm-linux-gnueabi-g++-10 ${CROSS_TRIPLE}-c++ && \
    ln -s arm-linux-gnueabi-strip ${CROSS_TRIPLE}-strip && \
    ln -s arm-linux-gnueabi-ranlib ${CROSS_TRIPLE}-ranlib
