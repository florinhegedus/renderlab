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

# get cuda version
CUDA_VERSION=$(nvidia-smi | grep -Po 'CUDA Version: \K[0-9]+\.[0-9]+')
CUDA_TAG="cu$(echo $CUDA_VERSION | tr -d '.')"
echo $CUDA_TAG

# conda
CONDA_PATH="/opt/miniforge3/etc/profile.d/conda.sh"

if [ -f "$CONDA_PATH" ]; then
    source "$CONDA_PATH"
else
    echo "Error: conda.sh not found at $CONDA_PATH"
    exit 1
fi

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
    libglm-dev \
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
    imagemagick \
    nvidia-cuda-toolkit \
    nvidia-cuda-toolkit-gcc
sudo mkdir -p /usr/include/opencv4

# install colmap
git clone https://github.com/colmap/colmap.git
cd colmap
mkdir build
cd build
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
conda create --name gsplat_env python=3.11 -y
conda activate gsplat_env
pip install torch torchvision torchaudio --index-url "https://download.pytorch.org/whl/${CUDA_TAG}"
pip install -e . --no-build-isolation
cd /workspace/gsplat/examples
pip install -r requirements.txt --no-build-isolation
