import argparse
import os
import shutil
from pathlib import Path


def crop(scene_path, dest_path, start_idx, end_idx):
    """ Crop scene from start_idx to end_idx. 
    
    Args:
        scene_path (str): path to scene.
        dest_path  (str): path where to save the cropped scene.
        start_idx  (int): start index of the crop interval.
        end_idx    (int): end index of the crop interval.
    """
    # copy original scene
    shutil.copytree(scene_path, dest_path)
    image_dir = Path(dest_path) / "images"
    frames = sorted([f for ext in ("*.jpg", "*.png") for f in image_dir.glob(ext, case_sensitive=False)], 
                    key=lambda path: path.stem)
    
    # crop interval
    start_idx = max(0, start_idx)
    end_idx   = min(len(frames), end_idx)
    print(f"Total number of frames: {len(frames)}.")
    print(f"Number of frames after crop: {end_idx - start_idx}")

    # delete frames
    for idx, frame in enumerate(frames):
        if idx < start_idx or idx > end_idx:
            os.remove(frame)

    # delete folders
    for path in Path(dest_path).iterdir():
        if path.name != "images":
            if path.is_dir():
                shutil.rmtree(path)
            else:
                os.remove(path)
    

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--scene_path", type=str, help="path to scene directory")
    parser.add_argument("--dest_path",  type=str, help="path to scene directory")
    parser.add_argument("--start_idx",  type=int, help="start index")
    parser.add_argument("--end_idx",    type=int, help="end index")
    args = parser.parse_args()
    crop(scene_path=args.scene_path,
         dest_path=args.dest_path,
         start_idx=args.start_idx,
         end_idx =args.end_idx,
    )
