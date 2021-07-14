#!/bin/sh

# Hybrid Parallel
use_hybrid=false
if "${use_hybrid}"; then
  FOPENMP=-fopenmp
  DOMP=-D_OPENMP
else
  FOPENMP=
  DOMP=
fi

# Ftrace
use_ftrace=false
if "${use_ftrace}"; then
  FTRACEFLAGS=-ftrace
  DFTRACEFLAGS=-D__NECFTRACE
else
  FTRACEFLAGS=
  DFTRACEFLAGS=
fi

QE_DIR=`pwd`
PROGINF="-report-all"
NLC_LIB="-L${NLC_HOME}/lib"
ELPA_DIR="${QE_DIR}/elpa"

./configure --enable-parallel --with-scalapack    \
--host=aurora ARCH=aurora-veos                    \
AR=nar ARFLAGS=rv                                 \
FC="mpinfort"                                     \
CC="ncc"                                          \
CFLAGS="${PROGINF} ${FOPENMP} ${FTRACEFLAGS}"     \
F77="nfort"                                       \
FFLAGS="${PROGINF} ${FOPENMP} ${FTRACEFLAGS}"     \
F90="nfort"                                       \
F90FLAGS="${PROGINF} ${FOPENMP} ${FTRACEFLAGS}"   \
FFLAGS_NOOPT="-O0 ${PROGINF} ${FTRACEFLAGS}"      \
CPP="" CPPFLAGS=""                                \
LDFLAGS="${FOPENMP} ${FTRACEFLAGS}"               \
LD_LIBS=""                                        \
BLAS_LIBS="${NLC_LIB} -lblas_sequential"          \
LAPACK_LIBS="${NLC_LIB} -llapack"                 \
SCALAPACK_LIBS="-L${ELPA_DIR} ${NLC_LIB} -lscalapack -lelpa" \
FFT_LIBS="${NLC_LIB} -laslfftw3 -lasl_sequential"            \
DFLAGS="-D__SX6 -D__ARR -D__MPI -D__PARA -D__SCALAPACK -D__FFTW3 -D__NLC -D__NEC -D__ZGEMM3M -D__NON_BLOCKING_SCATTER -D__ELPA ${DFTRACEFLAGS}" \
IFLAGS="-I${NLC_HOME}/include -I../FoX/finclude -I../../FoX/finclude -I../include" \
USEFTRACE=${use_ftrace}
