## GSplat
1. Download example:
First, copy `examples/download_dataset.py` from this repo to `gsplat/examples/datasets/download_dataset.py`.
```bash
cd /workspace/gsplat/examples
pyton dataset/download_dataset.py
cd /workspace/gsplat
```

2. Train
- 3DGS
```bash
CUDA_VISIBLE_DEVICES=0 python simple_trainer.py default \
    --data_dir gsplat/examples/data/zipnerf_undistorted/nyc \
    --data_factor 4 \
    --result_dir ./results/nyc \
    --save_ply
```

- 3DGUT
```bash
CUDA_VISIBLE_DEVICES=0 python simple_trainer.py mcmc --with_ut --with_eval3d \
    --data_dir data/living-fisheye \
    --data_factor 2 \
    --result_dir ./results/living-fisheye \
    --save_ply
    --camera_model fisheye \
```

3. Viewer:
```bash
CUDA_VISIBLE_DEVICES=0 python -m simple_viewer \
        --ckpt results/nyc/ckpts/ckpt_29999_rank0.pt \
        --output_dir results/nyc/ \
        --port 8082
```

4. From trained gaussians to point cloud:
```bash
CUDA_VISIBLE_DEVICES=0 python -m simple_converter \
        --ckpt results/nyc/ckpts/ckpt_29999_rank0.pt \
        --output_dir results/nyc
```
