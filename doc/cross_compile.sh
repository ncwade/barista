#!/usr/bin/env bash

## binutils-gdb
# git clone git://sourceware.org/git/binutils-gdb.git
# ../configure --disable-nls --target=x86_64-elf --disable-werror --enable-gold=yes --disable-gdb --with-sysroot --prefix=$HOME/Development/crossbuild

## Create archive of build deps from deb packages (extract to create sysroot on build machine)
# sudo aptitude download libc6 libc6-dev libgcc-4.9-dev libgcc1 libstdc++6 libstdc++-4.9-dev
# mkdir sysroot
# for i in *.deb; do ar xv $i; tar -C sysroot -xf data.tar*; rm data.tar*; done
# cd sysroot && tar -czf ../sysroot.tar.gz * && cd -

# mkdir -p .brew/toolchain/x86_64-unknown-linux-elf/sysroot

CC=/usr/local/Cellar/llvm/3.6.2/bin/clang
CXX=/usr/local/Cellar/llvm/3.6.2/bin/clang++

CXX_FLAGS="-std=c++14"
# CXX_FLAGS="-std=c++14 -stdlib=libc++"

# VERBOSE="-v"
# VERBOSE="-v -Wl,--verbose"

# TARGET_TRIPLE=powerpc-wrs-linux-gnu
# SYSROOT=/opt/sysroot/fsl_8572ds-glibc_cgl/sysroot
# EXEC_PREFIX=/opt/sysroot/fsl_8572ds-glibc_cgl/powerpc-wrs-linux-gnu

# TARGET_TRIPLE=x86_64-unknown-linux-elf
# SYSROOT=$HOME/Development/crossbuild/sysroot
# EXEC_PREFIX=$HOME/Development/crossbuild/x86_64-elf/bin

SWD="$(cd "$(dirname "$0")"; pwd -P)" # script working directory
BREW=$SWD/../.brew

TARGET_TRIPLE=x86_64-unknown-linux-elf
SYSROOT=$BREW/toolchain/$TARGET_TRIPLE/sysroot
EXEC_PREFIX=$BREW/toolchain/$TARGET_TRIPLE/bin

if [[ "$1" == "--fix-links" ]]; then
   ## Redirect absolute symlinks in sysroot
   for f in $(find $SYSROOT -type l); do
      readlink $f | grep "^/"
      if [[ $? -eq 0 ]]; then
         ln -sf $SYSROOT/$(readlink $f) $f
      fi
   done
fi

CODE='#include <stdio.h>
int main()
{
   puts("Hello, world!");
   return 0;
}'

echo "$CODE" | $CC $VERBOSE -target ${TARGET_TRIPLE} -x c - -o hello_world --sysroot=$SYSROOT -B $EXEC_PREFIX

echo "$CODE" | $CXX $CXX_FLAGS $VERBOSE -target ${TARGET_TRIPLE} -x c++ - -o hello_worldpp --sysroot=$SYSROOT -B $EXEC_PREFIX
