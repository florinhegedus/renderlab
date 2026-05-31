## Setup
Instructions to setup environment for gaussian splat training.

> [!IMPORTANT]  
> Steps 4 and 5 are mandatory. COLMAP installation can be skipped.

1. Create pytorch instance from the templates page: [link](https://cloud.vast.ai/templates/).
2. Connect from vscode using given ssh command from instance details page.
3. Optional - deactivate auto tmux: `touch ~/.no_auto_tmux`
4. Set environment variables:
```bash
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export CUDACXX=/usr/local/cuda/bin/nvcc
export CUDA_HOME=/usr/local/cuda
export CUDA_ROOT=/usr/local/cuda
```
5. Install linux packages, COLMAP and gsplat dependencies:
```bash
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
```
6. Install colmap (details: [docs](https://colmap.github.io/install.html), [issue](https://github.com/colmap/colmap/issues/1431#issuecomment-3209387373)):
```bash
sudo mkdir -p /usr/include/opencv4
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
```
7. Install gsplat:
```bash
git clone https://github.com/nerfstudio-project/gsplat.git
cd workspace/gsplat
apt-get install libglm-dev
/opt/miniforge3/condabin/conda init
/opt/miniforge3/condabin/conda create --name gsplat_env python=3.11 -y
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu132
pip install -e . --no-build-isolation
cd workspace/gsplat/examples
pip install -r requirements.txt --no-build-isolation
```

8. Download example and train gaussians:
First, copy `examples/download_dataset.py` from this repo to `gsplat/examples/datasets/download_dataset.py`.
```bash
cd /workspace/gsplat/examples
pyton dataset/download_dataset.py
cd /workspace/gsplat
python 
CUDA_VISIBLE_DEVICES=0 python simple_trainer.py default \
    --data_dir data/zipnerf/nyc --data_factor 4 \
    --result_dir ./results/nyc
```


9. Install mapanything and export outputs in COLMAP format:
```bash
git clone https://github.com/facebookresearch/map-anything.git
cd map-anything
conda create -n mapanything python=3.12 -y
conda activate mapanything
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu132
pip install -e .
```
Check [mapanything-gsplat-support](https://github.com/facebookresearch/map-anything#colmap--gsplat-support):
```bash
python scripts/demo_colmap.py --images_dir=/workspace/repos/gsplat/examples/data/zipnerf/nyc --output_dir=/workspace/repos/gsplat/examples/data/zipnerf/nyc_COLMAP
```
