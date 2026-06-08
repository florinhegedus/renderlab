#!/bin/bash

# break if a command throws error
set -e

# env variables
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export CUDACXX=/usr/local/cuda/bin/nvcc
export CUDA_HOME=/usr/local/cuda
export CUDA_ROOT=/usr/local/cuda

# get CUDA version
CUDA_MAJOR=$(nvidia-smi | grep -Po 'CUDA Version: \K[0-9]+')
CUDA_MINOR=$(nvidia-smi | grep -Po 'CUDA Version: [0-9]+\.\K[0-9]+')

conda create -n colmap python=3.12
conda config --add channels conda-forge
conda config --set channel_priority strict
conda install \
    cmake \
    ninja \
    boost \
    ccache \
    eigen \
    openimageio \
    curl \
    metis \
    glog \
    gtest \
    ceres-solver \
    suitesparse \
    qt \
    glew \
    sqlite \
    cgal-cpp \
    mesa-libgl-devel-cos7-x86_64 \
    cuda-compiler==$CUDA_MAJOR.$CUDA_MINOR.* \
    cuda-cudart-dev \
    cuda-nvrtc-dev \
    libcurand-dev

git clone https://github.com/colmap/colmap.git
cd colmap
mkdir build
cd build
cmake .. -GNinja
ninja