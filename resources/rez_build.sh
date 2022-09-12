#!/bin/bash

echo "Build and install Rez with version:"
echo "SOURCE_REZ: ${SOURCE_REZ}"

echo "BOOTSTRAP_BUILD: ${BOOTSTRAP_BUILD}"
echo "BOOTSTRAP_THIRDPARTY: ${BOOTSTRAP_THIRDPARTY}"

BUILD_PATH=${BOOTSTRAP_BUILD}/rez-${COMP_REZ_VERS}
INSTALL_PATH=${BOOTSTRAP_PATH}/rez

echo "BUILD_PATH: $BUILD_PATH"
echo "INSTALL_PATH: $INSTALL_PATH"

rm -r -f $BUILD_PATH
rm -r -f $INSTALL_PATH

mkdir -p $BUILD_PATH
mkdir -p $INSTALL_PATH

# Untar source files
tar -xf $SOURCE_REZ -C $BUILD_PATH

# Move to the right paths
cd $BUILD_PATH
mv rez-* rez

# move into source dir
cd $BUILD_PATH/rez

# install using GCC phase 1 and Python
GCC_PATH=${BOOTSTRAP_THIRDPARTY}/gcc-${COMP_GCC_VERS}
echo "GCC_PATH phase 1: ${GCC_PATH}"
export PYTHONPATH=${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}:${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}/lib:${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}/lib/python3.7
echo "PYTHONPATH: ${PYTHONPATH}"
export PYTHONHOME=${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}
echo "PYTHONHOME: ${PYTHONHOME}"
export PATH=${GCC_PATH}/bin:${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}/bin:${PATH}
export CC=${GCC_PATH}/bin/gcc
export CXX=${GCC_PATH}/bin/g++
#export LD_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1:${LD_LIBRARY_PATH}:/usr/lib64
export LD_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1
export GCC_BINARY_PATH=${GCC_PATH}/bin
export CC_INCLUDE_PATH=${GCC_PATH}/include
export GCC_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1
echo "GCC version in use phase 1: $(gcc --version | head -n 1)"
echo "Python version in use: $(python --version | head -n 1)"

# print all sys modules
#python -c "import sys; print(sys.modules.keys());"

#Check if setuptools is installed
python -c "import setuptools;"
pip list

# install
python ./install.py -v $INSTALL_PATH
