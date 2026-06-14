## Gluemap

1. Run:
```bash
gluemap-demo \
    --config configs/example.yaml \
    --images_path /workspace/gsplat/examples/data/zipnerf_undistorted/nyc_gluemap \
    --intrinsics_mode SHARED \
    --write_path /workspace/gsplat/examples/data/zipnerf_undistorted/nyc_gluemap \
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

2. Install with newer version of torch:

Update pyproject.toml:
```text
[build-system]
requires = ["scikit-build-core>=0.10", "pybind11>=3.0"]
build-backend = "scikit_build_core.build"

[project]
name = "gluemap"
version = "0.1.0"
description = "GLUEMAP: feed-forward multi-view mapping built on COLMAP."
requires-python = ">=3.11"
authors = [{ name = "GLUEMAP contributors" }]

dependencies = [
    # Versions pinned to the known-good gluemap micromamba env.
    "numpy==2.4.3",
    "scipy==1.17.1",
    "torch",
    "torchvision",
    "pycolmap",
    "pyceres==2.6",
    "h5py==3.16.0",
    "networkx==3.6.1",
    "Pillow==12.2.0",
    "tqdm==4.67.3",
    "einops==0.8.2",
    "imagesize==2.0.0",
    "safetensors==0.7.0",
    "pyyaml==6.0.3",
    "faiss-cpu==1.13.2",
    # Transitive runtime deps of the vendored thirdparty/* repos
    # (mapanything, pi3, vggt, doppelgangers-plusplus). They are imported
    # at module load via thirdparty/path_to_thirdparty.py, so they need
    # to be available even though the repos themselves are not declared.
    "hydra-core==1.3.2",
    "omegaconf==2.3.0",
    "huggingface_hub",
    "opencv-python==4.13.0.92",
    "plyfile==1.1.3",
    "scikit-learn==1.8.0",
    "uniception==0.1.7",
    "pytorch-lightning==2.6.1",
    "pytorch-metric-learning==2.9.0",
    "lightglue @ git+https://github.com/cvg/LightGlue.git@eb42fee2d71449efb0aa5c10549752b5d75384d8",
]

[project.optional-dependencies]
dev = ["ruff", "pytest"]

[project.scripts]
gluemap-demo = "gluemap.cli:demo_main"
gluemap-benchmark = "benchmark.run_benchmark:main"

[tool.scikit-build]
cmake.source-dir = "gluemap/pybind"
cmake.version = ">=3.18"
wheel.packages = ["gluemap", "benchmark"]

[tool.pytest.ini_options]
testpaths = ["tests"]
```

Update `/workspace/gluemap/thirdparty/vggsfm/track_modules/track_refine.py` line 370:
```python
    from kornia.utils import create_meshgrid
```

Update:
```python
weights_only=True
```
