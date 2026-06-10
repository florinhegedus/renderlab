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
CUDA_MAJOR=$(nvidia-smi | grep -Po 'CUDA Version: \K[0-9]+')
CUDA_MINOR=$(nvidia-smi | grep -Po 'CUDA Version: [0-9]+\.\K[0-9]+')
if [ -z "$CUDA_MAJOR" ]; then
    echo "CUDA not found. Installing CPU/Default version."
else
    echo "Detected System CUDA: $CUDA_MAJOR.$CUDA_MINOR"
    if [ "$CUDA_MAJOR" -eq 12 ]; then
        if [ "$CUDA_MINOR" -ge 8 ]; then
            echo "System is CUDA 12.8+. Mapping to cu128."
            CUDA_TAG="cu128"
        elif [ "$CUDA_MINOR" -ge 6 ]; then
            echo "System is CUDA 12.6+. Mapping to cu126."
            CUDA_TAG="cu126"
        else
            echo "System is CUDA <12.6. Exiting, manually set CUDA version."
            exit 1
        fi
    elif [ "$CUDA_MAJOR" -eq 13 ]; then
        echo "System is CUDA 13.x. Mapping to cu130."
        CUDA_TAG="cu130"
    else
        echo "Unexpected CUDA generation."
        exit 1
    fi
fi

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
cd /workspace
git clone https://github.com/colmap/colmap.git
cd /workspace/colmap
git checkout f73c89db19099008184aade5f9e1f85dd9f77e76
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
git checkout 4e52698e45eaaed929ed3a5065e96a688d085df6
conda create --name gsplat_env python=3.12 -y
conda activate gsplat_env
pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url "https://download.pytorch.org/whl/${CUDA_TAG}"
pip install -e . --no-build-isolation
cd /workspace/gsplat/examples
pip install -r requirements.txt --no-build-isolation
python -m pip install -e ../libs/scene -e ../libs/stage

# install gluemap
cd /workspace
git clone https://github.com/colmap/gluemap.git
cd /workspace/gluemap
git checkout 866e25da4be97e166d804278c8910d21bf15ecd2
git submodule update --init --recursive
conda create --name gluemap_env python=3.12 -y
conda install -n gluemap_env -c conda-forge -y \
    eigen=3.4.0 \
    ceres-solver=2.2.0 \
    metis=5.1.0 \
    boost=1.85.0 \
    libstdcxx-ng=15.2.0 \
    pytorch-gpu=2.4.1 \
    torchvision=0.19.1 \
    cuda-version=12.4

conda activate gluemap_env
CMAKE_PREFIX_PATH=$CONDA_PREFIX pip install -e .

mkdir -p checkpoints

# SALAD retrieval
wget -O checkpoints/dino_salad.ckpt \
    https://github.com/serizba/salad/releases/download/v1.0.0/dino_salad.ckpt

# VGGSfM tracker (renamed to match base.yaml)
wget -O checkpoints/vggsfm_v2_0_0_track_predictor.bin \
    https://huggingface.co/facebook/VGGSfM/resolve/main/vggsfm_v2_tracker.pt

# Pi3 multiview model (huggingface_hub already in env)
pip install click
hf download yyfz233/Pi3 model.safetensors --local-dir checkpoints
mv checkpoints/model.safetensors checkpoints/pi3.safetensors

# Doppelgangers++
hf download doppelgangers25/doppelgangers_plusplus \
    checkpoint-dg+visym.pth --local-dir checkpoints

python -c "import gluemap; import pygluemap; print(pygluemap.__file__)"
gluemap-demo --help
gluemap-benchmark --help
pip install pytest
python -m pytest tests/
