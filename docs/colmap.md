## Sample Data
1. Camera pose estimation with COLMAP:
```bash
sudo apt install imagemagick
bash scripts/local_colmap_and_resize.sh /workspace/gsplat/examples/data/zipnerf_undistorted/nyc_crop_colmap_pinhole PINHOLE  # PINHOLE / OPENCV / OPENCV_FISHEYE
```
2. Resize:
```bash
bash scripts/local_colmap_and_resize.sh /workspace/gsplat/examples/data/zipnerf_undistorted/nyc_crop_colmap
```
