#!/usr/bin/env bash

## binutils-gdb
# git clone git://sourceware.org/git/binutils-gdb.git
# ../configure --disable-nls --target=x86_64-elf --disable-werror --enable-gold=yes --disable-gdb --with-sysroot --prefix=$HOME/Development/crossbuild

## Create archive(s) of build deps & extract to create sysroot on build machine
#
# tar -czf archive.tar.gz /usr/lib/x86_64-linux-gnu/ /usr/lib/gcc/x86_64-linux-gnu/ /lib/x86_64-linux-gnu/
# mkdir -p $HOME/Development/crossbuild/sysroot
# tar -C $HOME/Development/crossbuild/sysroot -xf archive.tar.gz
#
# sudo aptitude download libc6-dev
# ar vx libc6-dev_2.19-0ubuntu6.6_amd64.deb
# tar -tf data.tar.xz

## Redirect absolute symlinks in sysroot
# for f in $(find $HOME/Development/crossbuild/sysroot -type l); do
#    readlink $f | grep "^/"
#    if [[ $? -eq 0 ]]; then
#       ln -sf $HOME/Development/crossbuild/sysroot/$(readlink $f) $f
#    fi
# done

CC=/usr/local/Cellar/llvm/3.6.2/bin/clang
CXX=/usr/local/Cellar/llvm/3.6.2/bin/clang++

CXX_FLAGS="-std=c++14 -stdlib=libc++"

VERBOSE="-v"
# VERBOSE="-v -Wl,--verbose"

# TARGET_TRIPLE=powerpc-wrs-linux-gnu
# SYSROOT=/opt/sysroot/fsl_8572ds-glibc_cgl/sysroot
# EXEC_PREFIX=/opt/sysroot/fsl_8572ds-glibc_cgl/powerpc-wrs-linux-gnu

TARGET_TRIPLE=x86_64-unknown-linux-elf
SYSROOT=$HOME/Development/crossbuild/sysroot
EXEC_PREFIX=$HOME/Development/crossbuild/x86_64-elf/bin

$CC $VERBOSE -target ${TARGET_TRIPLE} hello_world.c -o hello_world --sysroot=$SYSROOT -B $EXEC_PREFIX

# $CXX $CXX_FLAGS --sysroot=$SYSROOT \
#                 hello_world.cpp -o hello_world $VERBOSE
