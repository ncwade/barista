#!/usr/bin/env bash

SWD="$(cd "$(dirname "$0")"; pwd -P)" # script working directory
BREW=$SWD/../.brew

# TARGET_TRIPLE=powerpc-wrs-linux-gnu
# SYSROOT=/opt/sysroot/fsl_8572ds-glibc_cgl/sysroot
# EXEC_PREFIX=/opt/sysroot/fsl_8572ds-glibc_cgl/powerpc-wrs-linux-gnu

# TARGET_TRIPLE=x86_64-unknown-linux-elf
# SYSROOT=$HOME/Development/crossbuild/sysroot
# EXEC_PREFIX=$HOME/Development/crossbuild/x86_64-elf/bin

TARGET_TRIPLE=x86_64-unknown-linux-elf
SYSROOT=$BREW/toolchain/$TARGET_TRIPLE/sysroot
EXEC_PREFIX=$BREW/toolchain/bin

CC=/usr/local/opt/llvm/bin/clang
CXX=/usr/local/opt/llvm/bin/clang++

## GCC options
# -nostdlib
# -nodefaultlibs
# -nostdinc
# -nostdinc++

# CXX_FLAGS="-std=c++14"
CXX_FLAGS="-std=c++14 -stdlib=libc++ -nostdinc++"

# VERBOSE="-v"
# VERBOSE="-v -Wl,--verbose"

CODE='
#include <stdio.h>
int main() {
   puts("Hello, world!");
   return 0;
}'

echo "$CODE" | $CC $VERBOSE -target ${TARGET_TRIPLE} -x c - -o hello_world --sysroot=$SYSROOT -B $EXEC_PREFIX


CXX_CODE='
#include <iostream>
#include <vector>

int main() {
   std::cout << "Hello, C++!" << std::endl;

   std::vector<int> vec = {1, 2, 3, 4, 5};
   for (auto i : vec) {
      std::cout << i << std::endl;
   }

   return 0;
}'

# -rpath-link: dylib equivalent of -L
# => tell linker to search for shared libraries in non-standard places,
# => but only for the purpose of verifying the link is correct

echo "$CXX_CODE" | $CXX $CXX_FLAGS                                         \
                        $VERBOSE                                           \
                        -target ${TARGET_TRIPLE}                           \
                        --sysroot=$SYSROOT                                 \
                        -B$EXEC_PREFIX                                     \
                        -Wl,-rpath-link,$SYSROOT/usr/lib/x86_64-linux-gnu/ \
                        -I$SYSROOT/usr/include/c++/v1                      \
                        -x c++ - -o hello_worldpp                          \
                        -lcxxrt -lpthread -ldl
