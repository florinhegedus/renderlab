import cv2
from pathlib import Path


if __name__ == "__main__":
    video_path = Path(rf"C:\D_partition\projects\render-lab\scenes\living-pinhole\GX010328.MP4")
    vid = cv2.VideoCapture(video_path)
    length = int(vid.get(cv2.CAP_PROP_FRAME_COUNT))
    step = 10
    print(f"{length} frames in total, extracting {length // step}...")
    outdir = video_path.parent / "images"
    outdir.mkdir(exist_ok=True)

    count, success = 0, True
    while success:
        success, image = vid.read() # Read frame
        if success: 
            if count % step == 0:
                cv2.imwrite(outdir / f"{count:06d}.jpg", image) # Save frame
                print(f"Saved {count:06d}.jpg")
            count += 1

    vid.release()
