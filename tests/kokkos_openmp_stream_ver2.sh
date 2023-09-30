#!/bin/bash

module load amdclang
module load rocm

PROB_NAME=kokkos_openmp_stream_ver2
mkdir ${PROB_NAME} && cd ${PROB_NAME}

PWDir=`pwd`

git clone https://github.com/kokkos/kokkos Kokkos_build
cd Kokkos_build

mkdir build_openmp && cd build_openmp
cmake -DCMAKE_INSTALL_PREFIX=${PWDir}/Kokkos_OpenMP -DKokkos_ENABLE_SERIAL=On \
      -DKokkos_ENABLE_OPENMP=On ..

make -j 8
make install

cd ../..

rm -rf Kokkos_build

export Kokkos_DIR=${PWDir}/Kokkos_OpenMP

git clone --recursive https://github.com/EssentialsOfParallelComputing/Chapter13 Chapter13
cd Chapter13/Kokkos/StreamTriad/Ver2
sed -i -e 's/80000000/100000/' StreamTriad.cc

export OMP_PROC_BIND=spread
export OMP_PLACES=threads

mkdir build && cd build
cmake ..
make
./StreamTriad

cd ${PWDir}
rm -rf Kokkos_OpenMP
rm -rf Chapter13

cd ..
rm -rf ${PROB_NAME}
