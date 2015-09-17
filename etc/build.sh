
rm -rf build
mkdir build && cd build

BREW=$HOME/Development/barista/.brew/ \
CC=/usr/local/Cellar/llvm/3.6.2/bin/clang \
CXX=/usr/local/Cellar/llvm/3.6.2/bin/clang++ \
INSTALL_PREFIX=/usr \
cmake -GNinja \
      -DCMAKE_TOOLCHAIN_FILE=$HOME/Development/barista/doc/clang_cross.toolchain.cmake \
      ..

ninja
# ninja install
# ninja package
