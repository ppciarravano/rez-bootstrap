#!/bin/bash

# Doc here: https://gcc.gnu.org/install/prerequisites.html
echo "Build and install gcc phase 1 with versions:"
echo "SOURCE_GCC: ${SOURCE_GCC}"
echo "SOURCE_GMP: ${SOURCE_GMP}"
echo "SOURCE_MPFR: ${SOURCE_MPFR}"
echo "SOURCE_MPC: ${SOURCE_MPC}"
echo "SOURCE_ISL: ${SOURCE_ISL}"
echo "SOURCE_CLOOG: ${SOURCE_CLOOG}"

echo "BOOTSTRAP_BUILD: ${BOOTSTRAP_BUILD}"
echo "BOOTSTRAP_THIRDPARTY: ${BOOTSTRAP_THIRDPARTY}"

BUILD_PATH=${BOOTSTRAP_BUILD}/gcc-${COMP_GCC_VERS}_phase_1
INSTALL_PATH=${BOOTSTRAP_THIRDPARTY}/gcc-${COMP_GCC_VERS}

# Build only if $INSTALL_PATH does not exist
if [ -d "${INSTALL_PATH}" ]
then
    echo "Already built in ${INSTALL_PATH}, delete dir to force the rebuild."
    return
fi

echo "BUILD_PATH: $BUILD_PATH"
echo "INSTALL_PATH: $INSTALL_PATH"

rm -r -f $BUILD_PATH
rm -r -f $INSTALL_PATH

mkdir -p $BUILD_PATH
mkdir -p $INSTALL_PATH

# Untar source files
tar -xf $SOURCE_GCC -C $BUILD_PATH
tar -xf $SOURCE_GMP -C $BUILD_PATH
tar -xf $SOURCE_MPFR -C $BUILD_PATH
tar -xf $SOURCE_MPC -C $BUILD_PATH
tar -xf $SOURCE_ISL -C $BUILD_PATH
tar -xf $SOURCE_CLOOG -C $BUILD_PATH

# Move to the right paths
cd $BUILD_PATH
mv gcc-* gcc
mv gmp-* gcc/gmp
mv mpfr-* gcc/mpfr
mv mpc-* gcc/mpc
mv isl-* gcc/isl
mv cloog-* gcc/cloog

# Patch created with:
# diff -Naur build/gcc-9.3.1/libsanitizer/sanitizer_common/  build_gcc_patched/gcc-9.3.1/libsanitizer/sanitizer_common/
# from https://801871.bugs.gentoo.org/attachment.cgi?id=724069
echo "applying  patch gcc_patch.patch ..."
patch -p0 -i ${BOOTSTRAP_SOFTWARE}/patches/gcc/${COMP_GCC_VERS}/gcc_patch.patch

# move into source dir
cd $BUILD_PATH/gcc

# Build GCC phase 1 using GCC phase 0
# https://stackoverflow.com/questions/39883865/why-multiple-passes-for-building-linux-from-scratch-lfs
GCC_PATH=${BOOTSTRAP_THIRDPARTY}/gcc-${COMP_GCC_VERS}_phase_0
echo "GCC_PATH phase 0: ${GCC_PATH}"
export PATH=${GCC_PATH}/bin:${PATH}
export CC=${GCC_PATH}/bin/gcc
export CXX=${GCC_PATH}/bin/g++
#export LD_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1:${LD_LIBRARY_PATH}:/usr/lib64
export GCC_BINARY_PATH=${GCC_PATH}/bin
export CC_INCLUDE_PATH=${GCC_PATH}/include
export GCC_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1
echo "GCC version in use phase 0: $(gcc --version | head -n 1)"

# configure
./configure \
    --prefix=${INSTALL_PATH} \
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
    --with-pic \
    --enable-languages=c,c++ \
    --disable-multilib \
    --disable-bootstrap \
    --enable-threads=posix

# build
make -j${BOOTSTRAP_CPUCORES}

# install
make install
