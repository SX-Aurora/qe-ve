#!/bin/sh

PREFIX=${ELPADIR}

./configure \
CC="mpincc" \
CFLAGS="" \
CXX="mpinc++" \
CXXFLAGS="" \
LDFLAGS="-static -static-nec -L/opt/nec/ve/nlc/2.3.0/lib" \
LIBS="-lscalapack -llapack -lblas_sequential" \
CPPFLAGS="" \
FC="mpinfort" \
FCFLAGS="-fpp-name=cpp -Wp,-traditional -I`pwd`/private_modules" \
CPP="cpp" \
CXXPP="cpp" \
AR="nar" \
LD="mpinfort " \
RANLIB="nranlib" \
NM="nnm" \
FC_MODOUT="" \
MPI_BINARY="mpirun" \
--prefix=${PREFIX} --disable-sse --disable-sse-assembly --disable-avx --disable-avx2 -disable-avx512 --host=x86_64 --disable-c-tests
