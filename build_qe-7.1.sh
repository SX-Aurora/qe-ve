#!/bin/bash

ELPA_ROOT=${ELPADIR}

WORKDIR=`pwd`

ncc --version
nfort --version

mkdir ./build
cd ./build

  cmake\
  -DCMAKE_TOOLCHAIN_FILE=/opt/nec/ve/share/cmake/toolchainVE-MPI.cmake\
  -DCMAKE_Fortran_LINK_EXECUTABLE='<CMAKE_Fortran_COMPILER> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -lveftrace'\
  -DCMAKE_Fortran_COMPILER_ID="aurora"\
  -DCMAKE_Fortran_FLAGS="${FTRACE} -g -report-all -fpp -I../src/ -I../../ \
    -I${WORKDIR}/build/UtilXlib\
    -I${WORKDIR}/build/upflib\
    -I${WORKDIR}/build/XClib\
    -I${WORKDIR}/build/FFTXlib/src\
    -I${WORKDIR}/build/dft-d3\
    -I${WORKDIR}/build/Modules\
    -I${WORKDIR}/build/external\
    -I${WORKDIR}/build/external/fox/fsys\
    -I${WORKDIR}/build/external/fox/utils\
    -I${WORKDIR}/build/external/fox/sax\
    -I${WORKDIR}/build/external/fox/wxml\
    -I${WORKDIR}/build/external/fox/common\
    -I${WORKDIR}/build/external/fox/dom\
    -I${ELPA_ROOT}/include/elpa-2022.05.001/modules"\
  -DQE_ENABLE_ELPA=yes\
  -DELPA_USE_STATIC_LIBS=yes\
  -DELPA_ROOT=${ELPA_ROOT}\
  -DQE_ENABLE_SCALAPACK=yes\
  -DQE_ENABLE_MPI_MODULE=yes\
  -DQE_ENABLE_CUDA=no\
  -DQE_FFTW_VENDOR=FFTW3\
  -DFFTW3_ROOT=${NLC_HOME}\
  -DFFTW3_FOUND=true\
  -DFFTW3_LIBRARIES="${NLC_HOME}/lib/libaslfftw3_mpi.a;${NLC_HOME}/lib/libasl_mpi_sequential.a"\
  -DFFTW3_INCLUDE_DIRS="${NLC_HOME}/include"\
  -D__ZGEMM3M=1\
  ..

make pw
