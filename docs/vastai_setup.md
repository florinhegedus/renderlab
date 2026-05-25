## Setup
1. Create pytorch instance from the templates page: [link](https://cloud.vast.ai/templates/).
2. Connect from vscode using given ssh command from instance details page.
3. Optional - deactivate auto tmux: `touch ~/.no_auto_tmux`
4. Install colmap (details: [docs](https://colmap.github.io/install.html), [issue](https://github.com/colmap/colmap/issues/1431#issuecomment-3209387373)):
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
sudo mkdir -p /usr/include/opencv4
export PATH=/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
export CUDACXX=/usr/local/cuda/bin/nvcc
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
5. Install gsplat:
```bash
git clone 
cd gsplat
apt-get install libglm-dev
pip install -e . --no-build-isolation
cd examples
pip install -r requirements.txt --no-build-isolation
```
