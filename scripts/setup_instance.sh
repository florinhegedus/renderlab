#!/bin/bash

set -e

# install colmap dependencies
cd /workspace
sudo apt-get install -y \
    git \
    cmake \
    ninja-build \
    build-essential \
    libboost-program-options-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libeigen3-dev \
    libopenimageio-dev \
    openimageio-tools \
    libmetis-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libgmock-dev \
    libsqlite3-dev \
    libglew-dev \
    qt6-base-dev \
    libqt6opengl6-dev \
    libqt6openglwidgets6 \
    libcgal-dev \
    libceres-dev \
    libsuitesparse-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libmkl-full-dev \
    nvidia-cuda-toolkit \
    nvidia-cuda-toolkit-gcc
sudo mkdir -p /usr/include/opencv4
export PATH=/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
export CUDACXX=/usr/local/cuda/bin/nvcc

# install colmap
git clone https://github.com/colmap/colmap.git
cd colmap
mkdir build
cd build
sudo apt-get install -y \
    nvidia-cuda-toolkit \
    nvidia-cuda-toolkit-gcc
cmake .. -GNinja \
    -DCUDA_ENABLED=ON \
    -DGUI_ENABLED=OFF \
    -DOPENGL_ENABLED=OFF \
    -DCOLMAP_FIND_QUIETLY=ON \
    -DCMAKE_CUDA_ARCHITECTURES=native
ninja -j$(nproc)
sudo ninja install

# install gsplat
cd /workspace
git clone https://github.com/nerfstudio-project/gsplat.git
cd /workspace/gsplat
apt-get install libglm-dev
conda activate main
pip install -e . --no-build-isolation
cd /workspace/gsplat/examples
pip install -r requirements.txt --no-build-isolation

# download vocabtree
cd /workspace
wget https://github.com/colmap/colmap/releases/download/3.11.1/vocab_tree_flickr100K_words32K.bin
