import cv2
from pathlib import Path


vid = cv2.VideoCapture(rf"C:\D_partition\projects\render-lab\scenes\sufragerie-f\GX010313.MP4")
outdir = Path(rf"C:\D_partition\projects\render-lab\scenes\sufragerie-f\frames")

count, success = 0, True
while success:
    success, image = vid.read() # Read frame
    if success: 
        cv2.imwrite(outdir / f"{count:06d}.jpg", image) # Save frame
        count += 1

vid.release()