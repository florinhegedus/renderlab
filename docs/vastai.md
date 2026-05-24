## Setup
1. Create pytorch instance from the templates page: [link](https://cloud.vast.ai/templates/).
2. Connect from vscode through SSH.
3. Check torch is installed in `main` conda env: `pip freeze`
4. Install colmap (details: [docs](https://colmap.github.io/install.html), [issue](https://github.com/colmap/colmap/issues/1431#issuecomment-3209387373)):
```bash
sudo apt-get install \
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
    libmkl-full-dev
sudo mkdir -p /usr/include/opencv4
git clone https://github.com/colmap/colmap.git
cd colmap
mkdir build
cd build
cmake .. -GNinja   -DCUDA_ENABLED=ON   -DGUI_ENABLED=OFF   -DOPENGL_ENABLED=OFF   -DCOLMAP_FIND_QUIETLY=ON
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


## Sample Data
4. Download zipnerf New York scene:
```bash
cd gsplat/examples
# update code inside datasets/download_dataset.py to download only one scene from zipnerf
python datasets/download_dataset.py
```
5. Run training:
```bash
CUDA_VISIBLE_DEVICES=0 python simple_trainer.py default \
    --data_dir data/zipnerf/nyc --data_factor 4 \
    --result_dir ./results/nyc
```