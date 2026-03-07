cross-compiler [![Build Status](https://github.com/elementumorg/libtorrent-go/workflows/build/badge.svg)](https://github.com/elementumorg/libtorrent-go/actions?query=workflow%3Abuild)

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

Based on Debian Stretch:
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

- android-arm (android-ndk with android-19, toolchain 4.9)
- android-arm64 (android-ndk with android-19, toolchain 4.9)
- android-x64 (android-ndk with android-21, toolchain 4.9)
- android-x86 (android-ndk with android-21, toolchain 4.9)
- darwin-x64 (clang-3.9, llvm-3.9-dev, libtool, libxml2-dev, uuid-dev, libssl-dev patch make cpio)
- linux-armv6 (gcc-7-arm-linux-gnueabihf)
- linux-armv7 (gcc-7-arm-linux-gnueabihf)
- linux-arm64 (aarch64-linux-gnu)
- linux-x64
- linux-x86 (gcc-multilib, g++-multilib)
- windows-x64 (mingw-w64)
- windows-x86 (mingw-w64)

## Building

Either build all images with:

    make

Or selectively build platforms:

    make darwin-x64

## Release

Release is done by running `release.sh` script, that compiles all Docker images and pushes them to Docker Hub.