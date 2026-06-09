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

# conda
CONDA_PATH="/opt/miniforge3/etc/profile.d/conda.sh"

if [ -f "$CONDA_PATH" ]; then
    source "$CONDA_PATH"
else
    echo "Error: conda.sh not found at $CONDA_PATH"
    exit 1
fi

# install gluemap
git clone https://github.com/colmap/gluemap.git
cd gluemap
git submodule update --init --recursive
conda create --name gluemap_env python=3.12
conda install -n gluemap_env -c conda-forge \
    eigen=3.4.0 \
    ceres-solver=2.2.0 \
    metis=5.1.0 \
    boost=1.85.0 \
    libstdcxx-ng=15.2.0 \
    pytorch-gpu=2.4.1 \
    torchvision=0.19.1 \
    cuda-version=12.4

mkdir -p checkpoints

# SALAD retrieval
wget -O checkpoints/dino_salad.ckpt \
    https://github.com/serizba/salad/releases/download/v1.0.0/dino_salad.ckpt

# VGGSfM tracker (renamed to match base.yaml)
wget -O checkpoints/vggsfm_v2_0_0_track_predictor.bin \
    https://huggingface.co/facebook/VGGSfM/resolve/main/vggsfm_v2_tracker.pt

# Pi3 multiview model (huggingface_hub already in env)
hf download yyfz233/Pi3 model.safetensors --local-dir checkpoints
mv checkpoints/model.safetensors checkpoints/pi3.safetensors

# Doppelgangers++
hf download doppelgangers25/doppelgangers_plusplus \
    checkpoint-dg+visym.pth --local-dir checkpoints

python -c "import gluemap; import pygluemap; print(pygluemap.__file__)"
gluemap-demo --help
gluemap-benchmark --help
pytest tests/
