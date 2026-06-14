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

# install gluemap
cd /workspace
git clone https://github.com/colmap/gluemap.git
cd /workspace/gluemap
git checkout 866e25da4be97e166d804278c8910d21bf15ecd2
git submodule update --init --recursive
conda create --name gluemap_env python=3.12 -y
conda activate gluemap_env
conda install -n gluemap_env -c conda-forge -y \
    eigen=3.4.0 \
    ceres-solver=2.2.0 \
    metis=5.1.0 \
    boost=1.85.0 \
    libstdcxx-ng=15.2.0 \
    pytorch-gpu=2.11.0 \
    torchvision==0.26.0 \
    cuda-version=13.0
CMAKE_PREFIX_PATH=$CONDA_PREFIX pip install -e .

pip install click huggingface-hub --upgrade
mkdir -p checkpoints

# SALAD retrieval
wget -O checkpoints/dino_salad.ckpt \
    https://github.com/serizba/salad/releases/download/v1.0.0/dino_salad.ckpt

# VGGSfM tracker (renamed to match base.yaml)
wget -O checkpoints/vggsfm_v2_0_0_track_predictor.bin \
    https://huggingface.co/facebook/VGGSfM/resolve/main/vggsfm_v2_tracker.pt

# Pi3 multiview model (huggingface_hub already in env)
export HF_HUB_DISABLE_UPDATE_CHECK=1
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
