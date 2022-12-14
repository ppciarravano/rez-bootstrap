#!/bin/bash

# # find SCRIPT_ABS_PATH
# # If $0 is a symlink, resolve it to a file
# f="$0"
# if [ -L "$f" ]; then
#     f="$(readlink -f "$f" 2> /dev/null)"
#     if [ "$?" != "0" ]; then
# 	f="$0"
#     fi
# fi
# SCRIPT_RELATIVE_PATH="$(dirname "$f")"
# cd $SCRIPT_RELATIVE_PATH
# SCRIPT_ABS_PATH=`pwd`

COMP_GCC_VERS="__COMP_GCC_VERS__"
COMP_PYTHON_VERS="__COMP_PYTHON_VERS__"
COMP_CMAKE_VERS="__COMP_CMAKE_VERS__"
export BOOTSTRAP_PATH=__BOOTSTRAP_PATH__
BOOTSTRAP_THIRDPARTY=${BOOTSTRAP_PATH}/thirdparty
GCC_PATH=${BOOTSTRAP_THIRDPARTY}/gcc-${COMP_GCC_VERS}

# GCC and Python
#export PYTHONPATH=${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}:${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}/lib:${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}/lib/python3.7
#export PYTHONHOME=${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}
export PATH=${GCC_PATH}/bin:${BOOTSTRAP_THIRDPARTY}/python-${COMP_PYTHON_VERS}/bin:${PATH}
export CC=${GCC_PATH}/bin/gcc
export CXX=${GCC_PATH}/bin/g++
#export LD_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1:${LD_LIBRARY_PATH}:/usr/lib64
export LD_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1
export GCC_BINARY_PATH=${GCC_PATH}/bin
export CC_INCLUDE_PATH=${GCC_PATH}/include
export GCC_LIBRARY_PATH=${GCC_PATH}/lib64:${GCC_PATH}/lib/gcc/x86_64-pc-linux-gnu/9.3.1

# CMake
export PATH=${BOOTSTRAP_THIRDPARTY}/cmake-${COMP_CMAKE_VERS}/bin:${PATH}
export CMAKE_BINARY_PATH=${BOOTSTRAP_THIRDPARTY}/cmake-${COMP_CMAKE_VERS}/bin

# Rez
#export REZ_ENV_PROMPT=
export PATH=${BOOTSTRAP_PATH}/rez/bin/rez:${PATH}
export REZ_CONFIG_FILE=${BOOTSTRAP_PATH}/config/rezconfig.py
echo "REZ_CONFIG_FILE: ${REZ_CONFIG_FILE}"
export REZ_REPO_PAYLOAD_DIR=${BOOTSTRAP_PATH}/software
export REZ_TMP_PATH=${BOOTSTRAP_PATH}/tmp
source ${BOOTSTRAP_PATH}/rez/completion/complete.sh

echo "Rez is ready to be used!"
