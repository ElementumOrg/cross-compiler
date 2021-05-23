FROM elementumorg/cross-compiler:base

ENV CROSS_ROOT /usr/osxcross
ENV PATH ${PATH}:${CROSS_ROOT}/bin:${CROSS_ROOT}/go/bin
ENV LD_LIBRARY_PATH /usr/lib/llvm-4.0/lib:${CROSS_ROOT}/lib:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH ${CROSS_ROOT}/lib/pkgconfig:${PKG_CONFIG_PATH}
ENV MAC_SDK_VERSION 10.14

RUN apt-get install -y --force-yes apt-utils apt-transport-https libcurl4-openssl-dev libmpc-dev libmpfr-dev libgmp-dev libc6-dev

RUN echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-4.0 main" >> /etc/apt/sources.list && \
    wget --no-check-certificate -qO - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y --force-yes clang-4.0 llvm-4.0-dev automake autogen \
                                   libtool libxml2-dev uuid-dev libssl-dev bash \
                                   patch make tar xz-utils bzip2 gzip sed cpio git zlib1g-dev

RUN curl -L https://github.com/tpoechtrager/osxcross/archive/master.tar.gz | tar xz && \
    cd /osxcross-master/ && \
    curl -Lo tarballs/MacOSX${MAC_SDK_VERSION}.sdk.tar.xz \
      https://storage.googleapis.com/obs-ci-cache/beats/MacOSX${MAC_SDK_VERSION}.sdk.tar.xz && \
    ln -s /usr/bin/clang-4.0 /usr/bin/clang && \
    ln -s /usr/bin/clang++-4.0 /usr/bin/clang++ && \
    echo | SDK_VERSION=${MAC_SDK_VERSION} OSX_VERSION_MIN=10.9 UNATTENDED=1 ./build.sh && \
    ./build_gcc.sh && \
    mv /osxcross-master/target ${CROSS_ROOT} && \
    mkdir -p ${CROSS_ROOT}/lib && \
    cd / && rm -rf /osxcross-master

ENV CROSS_TRIPLE x86_64-apple-darwin18
RUN ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar ${CROSS_ROOT}/bin/ar && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as ${CROSS_ROOT}/bin/as && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-strip ${CROSS_ROOT}/bin/strip && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ranlib ${CROSS_ROOT}/bin/ranlib && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-nm ${CROSS_ROOT}/bin/nm && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ld ${CROSS_ROOT}/bin/ld && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cc ${CROSS_ROOT}/bin/cc && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-c++ ${CROSS_ROOT}/bin/c++ && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc ${CROSS_ROOT}/bin/gcc && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++ ${CROSS_ROOT}/bin/g++
