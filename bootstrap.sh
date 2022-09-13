#!/bin/bash

# Author: Pier Paolo Ciarravano (http://www.larmor.com)

# requirements for bootstrap:
# tar (GNU tar) 1.34 
# python 3
# gcc compiler for build gcc
# flex
# readline-devel
#
# libffi-dev
# libgdbm-compat-dev
# libbz2-dev
# libsqlite3-dev
# uuid-dev
# libreadline-dev
# libgdbm-dev
#

# exit when any command fails
set -e

# define component versions
COMP_GCC_VERS="9.3.1"
COMP_GMP_VERS="6.2.1"
COMP_MPFR_VERS="4.1.0"
COMP_MPC_VERS="1.2.1"
COMP_ISL_VERS="0.24"
COMP_CLOOG_VERS="0.18.4"
COMP_PYTHON_VERS="3.7.13"
COMP_REZ_VERS="2.111.3"

# path for final destination of python/gcc/rez/lunch scripts
BOOTSTRAP_PATH=`pwd`

# path to build all the startup components
BOOTSTRAP_BUILD=${BOOTSTRAP_PATH}/build
mkdir -p $BOOTSTRAP_BUILD

# path where to store the installation tarballs
BOOTSTRAP_SOFTWARE=${BOOTSTRAP_PATH}/software
mkdir -p $BOOTSTRAP_SOFTWARE

# path where to store the installed third-party software that Rez needs: Python and GCC
BOOTSTRAP_THIRDPARTY=${BOOTSTRAP_PATH}/thirdparty
mkdir -p $BOOTSTRAP_THIRDPARTY

# numbers of CPU cores
BOOTSTRAP_CPUCORES=$(nproc --all)
# no stress CPU
#BOOTSTRAP_CPUCORES=1
echo "BOOTSTRAP_CPUCORES: ${BOOTSTRAP_CPUCORES}"

# resources path
BOOTSTRAP_RESOURCES=${BOOTSTRAP_PATH}/resources

# Download and check the software
cd $BOOTSTRAP_SOFTWARE
echo "Download and check software..."
${BOOTSTRAP_RESOURCES}/download_sources.py

# get component files source
GET_COMPONENT_DESTINATION_SCRIPT=${BOOTSTRAP_RESOURCES}/get_component_destination.py

echo "Compenent versions initialised:"
SOURCE_GCC=${BOOTSTRAP_SOFTWARE}/$(${GET_COMPONENT_DESTINATION_SCRIPT} gcc ${COMP_GCC_VERS})
SOURCE_GMP=${BOOTSTRAP_SOFTWARE}/$(${GET_COMPONENT_DESTINATION_SCRIPT} gmp ${COMP_GMP_VERS})
SOURCE_MPFR=${BOOTSTRAP_SOFTWARE}/$(${GET_COMPONENT_DESTINATION_SCRIPT} mpfr ${COMP_MPFR_VERS})
SOURCE_MPC=${BOOTSTRAP_SOFTWARE}/$(${GET_COMPONENT_DESTINATION_SCRIPT} mpc ${COMP_MPC_VERS})
SOURCE_ISL=${BOOTSTRAP_SOFTWARE}/$(${GET_COMPONENT_DESTINATION_SCRIPT} isl ${COMP_ISL_VERS})
SOURCE_CLOOG=${BOOTSTRAP_SOFTWARE}/$(${GET_COMPONENT_DESTINATION_SCRIPT} cloog ${COMP_CLOOG_VERS})
SOURCE_PYTHON=${BOOTSTRAP_SOFTWARE}/$(${GET_COMPONENT_DESTINATION_SCRIPT} python ${COMP_PYTHON_VERS})
SOURCE_REZ=${BOOTSTRAP_SOFTWARE}/$(${GET_COMPONENT_DESTINATION_SCRIPT} rez ${COMP_REZ_VERS})

cd $BOOTSTRAP_PATH
echo "SOURCE_GCC: ${SOURCE_GCC}"
echo "SOURCE_GMP: ${SOURCE_GMP}"
echo "SOURCE_MPFR: ${SOURCE_MPFR}"
echo "SOURCE_MPC: ${SOURCE_MPC}"
echo "SOURCE_ISL: ${SOURCE_ISL}"
echo "SOURCE_CLOOG: ${SOURCE_CLOOG}"
echo "SOURCE_PYTHON: ${SOURCE_PYTHON}"
echo "SOURCE_REZ: ${SOURCE_REZ}"

# build and install gcc phase 0
source ${BOOTSTRAP_RESOURCES}/gcc_build_phase_0.sh

# build and install gcc phase 1
source ${BOOTSTRAP_RESOURCES}/gcc_build_phase_1.sh

# build and install Python
source ${BOOTSTRAP_RESOURCES}/python_build.sh

# build and install Rez
source ${BOOTSTRAP_RESOURCES}/rez_build.sh
