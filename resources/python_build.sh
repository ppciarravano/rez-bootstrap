#!/bin/bash

echo "Build and install Python with version:"
echo "SOURCE_PYTHON: ${SOURCE_PYTHON}"

echo "BOOTSTRAP_BUILD: ${BOOTSTRAP_BUILD}"
echo "BOOTSTRAP_THIRDPARTY: ${BOOTSTRAP_THIRDPARTY}"

BUILD_PATH=${BOOTSTRAP_BUILD}/python-${COMP_PYTHON_VERS}
INSTALL_PATH=${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}

echo "BUILD_PATH: $BUILD_PATH"
echo "INSTALL_PATH: $INSTALL_PATH"

rm -r -f $BUILD_PATH
rm -r -f $INSTALL_PATH

mkdir -p $BUILD_PATH
mkdir -p $INSTALL_PATH

# Untar source files
tar -xf $SOURCE_PYTHON -C $BUILD_PATH

# Move to the right paths
cd $BUILD_PATH
mv Python-* python

# move into source dir
cd $BUILD_PATH/python

# Build Python using GCC phase 1
GCC_PATH=${BOOTSTRAP_THIRDPARTY}/gcc-${COMP_GCC_VERS}
echo "GCC_PATH phase 1: ${GCC_PATH}"
export PATH=${GCC_PATH}/bin:${PATH}
export CC=${GCC_PATH}/bin/gcc
export CXX=${GCC_PATH}/bin/g++
#export LD_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1:${LD_LIBRARY_PATH}:/usr/lib64
export LD_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1
export GCC_BINARY_PATH=${GCC_PATH}/bin
export CC_INCLUDE_PATH=${GCC_PATH}/include
export GCC_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1
echo "GCC version in use phase 1: $(gcc --version | head -n 1)"

# configure
./configure \
    --prefix=${INSTALL_PATH} \
    CFLAGS="-fPIC" \
    CXXFLAGS="-fPIC" \
    --enable-ipv6 \
    --with-ensurepip=install \
    --enable-unicode=ucs4

# build
make -j${BOOTSTRAP_CPUCORES}

# install
make install

# create links
cd $INSTALL_PATH/bin
ln -s python3 python
ln -s pip3 pip
