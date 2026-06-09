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

# install gsplat
cd /workspace
git clone https://github.com/nerfstudio-project/gsplat.git
cd /workspace/gsplat
conda create --name gsplat_env python=3.12 -y
conda activate gsplat_env
pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url "https://download.pytorch.org/whl/${CUDA_TAG}"
pip install -e . --no-build-isolation
cd /workspace/gsplat/examples
pip install -r requirements.txt --no-build-isolation
python -m pip install -e ../libs/scene -e ../libs/stage
