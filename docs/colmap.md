## Sample Data
1. Camera pose estimation with COLMAP:
```bash
sudo apt install imagemagick -y
bash local_colmap_and_resize.sh /workspace/gsplat/examples/data/sufragerie OPENCV_FISHEYE  # PINHOLE / OPENCV / OPENCV_FISHEYE
```
2. Resize:
```bash
bash resize.sh /workspace/gsplat/examples/data/sufragerie
```
