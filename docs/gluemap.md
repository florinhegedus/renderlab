## Gluemap

Run:
```bash
gluemap-demo \
    --config configs/example.yaml \
    --images_path /workspace/gsplat/examples/data/zipnerf_undistorted/nyc_glue \
    --intrinsics_mode SHARED \
    --write_path /workspace/gsplat/examples/data/zipnerf_undistorted/nyc_glue \
    --batch_size 4
```

```bash
gluemap-demo \
    --config configs/example.yaml \
    --images_path /workspace/gsplat/examples/data/zipnerf_undistorted/nyc_gluemap \
    --intrinsics_mode SHARED \
    --write_path /workspace/gsplat/examples/data/zipnerf_undistorted/nyc_gluemap \
    --batch_size 4 \
    --chosen_model map_anything \
    --path_feedforward facebook/map-anything
```
