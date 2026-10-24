FROM elementumorg/cross-compiler:base

ENV CROSS_ROOT="/usr/osxcross"
ENV PATH="${PATH}:${CROSS_ROOT}/bin:${CROSS_ROOT}/go/bin"
ENV LD_LIBRARY_PATH="${CROSS_ROOT}/lib"
ENV PKG_CONFIG_PATH="${CROSS_ROOT}/lib/pkgconfig"
# Go >= 1.26 needs a macOS 13 SDK and targets macOS 13.0
ENV MAC_SDK_VERSION="13.3"
ENV OSX_VERSION_MIN="13.0"
ENV CROSS_TRIPLE="aarch64-apple-darwin22.4"

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    apt-transport-https \
    libcurl4-openssl-dev \
    libc6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# clang >= 13 is needed for SDK 13 headers, 13 crashes building libtorrent for arm64 (musttail);
# 16 needs -Wno-enum-constexpr-conversion for Boost 1.72 (set in libtorrent-go cgo flags)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        clang-16 llvm-16-dev automake autogen \
        libtool libxml2-dev uuid-dev libssl-dev bash \
        patch make tar xz-utils bzip2 gzip sed cpio git zlib1g-dev \
        python3 liblzma-dev libbz2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# osxcross build needs cmake
ARG CMAKE_VERSION=3.20.3
RUN wget "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz" \
    --no-check-certificate -qO- | tar --strip-components=1 -xz --one-top-level=/usr

RUN curl -L https://github.com/tpoechtrager/osxcross/archive/master.tar.gz | tar xz && \
    cd /osxcross-master/ && \
    curl -sSLo "tarballs/MacOSX${MAC_SDK_VERSION}.sdk.tar.xz" \
        "https://github.com/joseluisq/macosx-sdks/releases/download/${MAC_SDK_VERSION}/MacOSX${MAC_SDK_VERSION}.sdk.tar.xz" && \
    ln -s /usr/bin/clang-16 /usr/bin/clang && \
    ln -s /usr/bin/clang++-16 /usr/bin/clang++ && \
    echo | SDK_VERSION=${MAC_SDK_VERSION} OSX_VERSION_MIN=${OSX_VERSION_MIN} UNATTENDED=1 ./build.sh && \
    mv /osxcross-master/target ${CROSS_ROOT} && \
    mkdir -p ${CROSS_ROOT}/lib && \
    cd / && rm -rf /osxcross-master

# Without build_gcc.sh osxcross has no -cc/-c++, they were clang anyway
RUN ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar ${CROSS_ROOT}/bin/ar && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as ${CROSS_ROOT}/bin/as && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-strip ${CROSS_ROOT}/bin/strip && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ranlib ${CROSS_ROOT}/bin/ranlib && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-nm ${CROSS_ROOT}/bin/nm && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ld ${CROSS_ROOT}/bin/ld && \
    ln -sf ${CROSS_TRIPLE}-clang ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cc && \
    ln -sf ${CROSS_TRIPLE}-clang++ ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-c++ && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cc ${CROSS_ROOT}/bin/cc && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-c++ ${CROSS_ROOT}/bin/c++
