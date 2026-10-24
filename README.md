cross-compiler [![Build Status](https://github.com/elementumorg/cross-compiler/workflows/build/badge.svg)](https://github.com/elementumorg/cross-compiler/actions?query=workflow%3Abuild)

==============

C/C++ Cross compiling environment containers

This has been designed to run `libtorrent-go` cross compilation and is not meant to be perfect nor minimal. Adapt as required.

## Overview

### Environment variables

- CROSS_TRIPLE
- CROSS_ROOT
- LD_LIBRARY_PATH
- PKG_CONFIG_PATH

Also adds CROSS_ROOT/bin in your PATH.

### Installed packages

Based on Debian Bullseye (installed from archive.debian.org, as Bullseye is EOL):
- bash
- curl
- wget
- pkg-config
- build-essential
- make
- automake
- autogen
- libtool
- libpcre3-dev
- bison
- yodl
- tar
- xz-utils
- bzip2
- gzip
- file
- rsync
- sed
- upx

And a selection of platform specific packages (see below).

### Platforms built

- android-arm, android-arm64, android-x64, android-x86 (Android NDK r20b standalone toolchain, clang, API 21 / Android 5.0+)
- darwin-x64, darwin-arm64 ([osxcross](https://github.com/tpoechtrager/osxcross) with macOS SDK 13.3, clang-16, minimum macOS 13.0)
- linux-armv6 (Raspberry Pi Linaro gcc toolchain, `arm-linux-gnueabihf`)
- linux-armv7 (`crossbuild-essential-armhf`, gcc 10)
- linux-armv7_softfp (`crossbuild-essential-armel`, gcc 10, `-mfloat-abi=softfp`)
- linux-arm64 (`crossbuild-essential-arm64`, gcc 10)
- linux-x64 (gcc 10)
- linux-x86 (gcc 10 with `-m32`, gcc-multilib)
- windows-x64 (mingw-w64 x86_64, gcc 10)
- windows-x86 (mingw-w64 i686, gcc 10)

## Building

Either build all images (4 in parallel by default) with:

    make

Use `make JOBS=1` to build one image at a time with full live output, or `make JOBS=8` for more parallel builds.

Or selectively build platforms:

    make darwin-arm64

## Release

Release is done by running `release.sh` script, that compiles all Docker images and pushes them to Docker Hub.