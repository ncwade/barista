
set(CMAKE_SYSTEM_NAME Linux) # tell CMake we cross-compile'n

set(BREW $ENV{BREW})
set(TARGET_TRIPLE x86_64-unknown-linux-elf)
set(TOOLCHAIN_ROOT ${BREW}/toolchain/${TARGET_TRIPLE}/)

# set(CMAKE_SYSROOT ${TOOLCHAIN_ROOT}/sysroot/)
set(PREFIX_PATH_OPTION -B${TOOLCHAIN_ROOT}/bin/)

# set(CMAKE_INSTALL_PREFIX ${CMAKE_SYSROOT}/$ENV{INSTALL_PREFIX} CACHE INTERNAL "CMAKE_INSTALL_PREFIX" FORCE)

set(CMAKE_C_COMPILER          $ENV{CC} ${PREFIX_PATH_OPTION})
set(CMAKE_C_COMPILER_TARGET   ${TARGET_TRIPLE})
set(CMAKE_CXX_COMPILER        $ENV{CXX} ${PREFIX_PATH_OPTION})
set(CMAKE_CXX_COMPILER_TARGET ${TARGET_TRIPLE})

set(CMAKE_AR ${TOOLCHAIN_ROOT}/bin/ar CACHE INTERNAL "CMAKE_AR" FORCE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_ROOT})

# include_directories(${CMAKE_SYSROOT}/usr/include/c++/v1/)

# Common compiler flags
set(FLAGS "-fcolor-diagnostics")
# set(FLAGS "-fcolor-diagnostics -v -Wl,--verbose")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FLAGS}" CACHE INTERNAL "CMAKE_C_FLAGS" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FLAGS}" CACHE INTERNAL "CMAKE_CXX_FLAGS" FORCE)
