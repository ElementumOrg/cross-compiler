FROM elementumorg/cross-compiler:base

ENV CROSS_TRIPLE="x86_64-linux-gnu"
ENV CROSS_ROOT="/usr/${CROSS_TRIPLE}"
ENV PATH="${PATH}:${CROSS_ROOT}/bin:${CROSS_ROOT}/go/bin"
ENV LD_LIBRARY_PATH="${CROSS_ROOT}/lib"
ENV PKG_CONFIG_PATH="${CROSS_ROOT}/lib/pkgconfig"

RUN mkdir -p ${CROSS_ROOT} && \
    cd /usr/bin && \
    ln -s ${CROSS_TRIPLE}-gcc ${CROSS_TRIPLE}-cc && \
    ln -s ${CROSS_TRIPLE}-g++ ${CROSS_TRIPLE}-c++
