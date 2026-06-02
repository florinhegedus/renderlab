import cv2
from pathlib import Path


if __name__ == "__main__":
    vid = cv2.VideoCapture(rf"C:\D_partition\projects\render-lab\scenes\sufragerie-f\GX010313.MP4")
    outdir = Path(rf"C:\D_partition\projects\render-lab\scenes\sufragerie-f\frames-10")
    outdir.mkdir(exist_ok=True)

    step = 10
    count, success = 0, True
    while success:
        success, image = vid.read() # Read frame
        if success: 
            if count % step == 0:
                cv2.imwrite(outdir / f"{count:06d}.jpg", image) # Save frame
                print(f"Saved {count:06d}.jpg")
            count += 1

    vid.release()
