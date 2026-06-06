## Sample Data
1. Camera pose estimation with COLMAP:
```bash
sudo apt install imagemagick -y
bash local_colmap_and_resize.sh /workspace/gsplat/examples/data/living-fisheye OPENCV_FISHEYE  # PINHOLE / OPENCV / OPENCV_FISHEYE
```
2. Resize:
```bash
bash resize.sh /workspace/gsplat/examples/data/sufragerie
```

3. Merge submodels:
```bash
colmap model_merger \
    --input_path1 /workspace/gsplat/examples/data/living-pinhole/sparse/0 \
    --input_path2 /workspace/gsplat/examples/data/living-pinhole/sparse/1 \
    --output_path /workspace/gsplat/examples/data/living-pinhole/sparse/2
```

4. Force only one model:
```bash
colmap mapper \
    --database_path "$DATASET_PATH"/database.db \
    --image_path "$DATASET_PATH"/images \
    --output_path "$DATASET_PATH"/sparse \
    --Mapper.ba_global_function_tolerance=0.000001 \
    --Mapper.multiple_models 0
```
