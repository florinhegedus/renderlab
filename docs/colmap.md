## Sample Data
1. Download zipnerf New York scene:
```bash
cd gsplat/examples
# update code inside datasets/download_dataset.py to download only one scene from zipnerf
python datasets/download_dataset.py
```
2. Run training:
```bash
CUDA_VISIBLE_DEVICES=0 python simple_trainer.py default \
    --data_dir data/zipnerf/nyc --data_factor 4 \
    --result_dir ./results/nyc
```
3. Camera pose estimation with COLMAP:
```bash
bash scripts/local_colmap_and_resize.sh /workspace/gsplat/examples/data/zipnerf/nyc_test
```