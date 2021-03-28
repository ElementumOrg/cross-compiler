FROM elementumorg/cross-compiler:base as ndk
WORKDIR /ndk

ENV NDK android-ndk-r20b
RUN wget -nv https://dl.google.com/android/repository/${NDK}-linux-x86_64.zip
RUN unzip ${NDK}-linux-x86_64.zip ${NDK}/toolchains/llvm/prebuilt/linux-x86_64/* 1>log 2>err 
RUN ln -s ${NDK}/toolchains/llvm/prebuilt/linux-x86_64/ toolchain

FROM elementumorg/cross-compiler:base as base

ENV CROSS_TRIPLE armv7a-linux-androideabi21
ENV CROSS_ROOT /usr/${CROSS_TRIPLE}
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV LD_LIBRARY_PATH ${CROSS_ROOT}/lib:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH ${CROSS_ROOT}/lib/pkgconfig:${PKG_CONFIG_PATH}

COPY --from=ndk /ndk/toolchain/arm-linux-androideabi/bin/ld ${CROSS_ROOT}/bin/
COPY --from=ndk /ndk/toolchain/bin/clang++ /ndk/toolchain/bin/clang /ndk/toolchain/bin/${CROSS_TRIPLE}-clang* ${CROSS_ROOT}/bin/
COPY --from=ndk /ndk/toolchain/bin/arm-linux-androideabi-ar ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar
COPY --from=ndk /ndk/toolchain/bin/arm-linux-androideabi-ranlib ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ranlib
COPY --from=ndk /ndk/toolchain/lib/gcc ${CROSS_ROOT}/lib/gcc/
COPY --from=ndk /ndk/toolchain/lib64/libc++.so.1 ${CROSS_ROOT}/lib64/
COPY --from=ndk /ndk/toolchain/lib64/clang ${CROSS_ROOT}/lib64/clang/
COPY --from=ndk /ndk/toolchain/sysroot/usr/include ${CROSS_ROOT}/sysroot/usr/include/
COPY --from=ndk /ndk/toolchain/sysroot/usr/lib/arm-linux-androideabi ${CROSS_ROOT}/sysroot/usr/lib/arm-linux-androideabi

RUN cd ${CROSS_ROOT}/bin && \
    ln -s ${CROSS_TRIPLE}-clang ${CROSS_TRIPLE}-gcc