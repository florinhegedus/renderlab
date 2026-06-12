## MapAnything

1. Install mapanything:
```bash
git clone https://github.com/facebookresearch/map-anything.git
cd map-anything
conda create -n mapanything python=3.12 -y
conda activate mapanything
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu132
pip install -e .
pip install -e ".[colmap]"
```

2. Run mapanything:
Check [mapanything-gsplat-support](https://github.com/facebookresearch/map-anything#colmap--gsplat-support):
```bash
python scripts/demo_colmap.py --images_dir=/workspace/gsplat/examples/data/zipnerf/nyc/images --output_dir=/workspace/gsplat/examples/data/zipnerf/nyc_COLMAP
```
