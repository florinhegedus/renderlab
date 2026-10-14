import bpy
import json
import math


scene = bpy.context.scene
camera = bpy.data.objects.get("Camera")

center_obj = bpy.data.objects.get("Empty")

if not camera:
    raise ValueError("Error: Could not find an object named 'Camera' in the scene.")
if not center_obj:
    raise ValueError("Error: Could not find 'CenterEmpty' or 'Turntable' to use as a center reference.")

render = scene.render
w = render.resolution_x
h = render.resolution_y

# Compute field of view
fov_x = camera.data.angle_x  # Blender natively stores angle_x in radians
fov_y = camera.data.angle_y if camera.data.angle_y else fov_x

output_data = {
    "camera_angle_x": fov_x,
    "camera_angle_y": fov_y,
    "w": w,
    "h": h,
    "fl_x": w / (2 * math.tan(fov_x / 2)),
    "fl_y": h / (2 * math.tan(fov_y / 2)),
    "cx": w / 2,
    "cy": h / 2,
    "frames": [],
}

for f in range(scene.frame_start, scene.frame_end + 1):
    scene.frame_set(f)
    bpy.context.view_layer.update()

    # Get world matrices
    mat_cam_world = camera.matrix_world
    mat_center_inv = center_obj.matrix_world.inverted()

    # Compute camera matrix relative to the center origin object
    mat_relative = mat_center_inv @ mat_cam_world

    # Convert Blender's 4x4 Mathutils matrix into a standard nested Python list
    transform_matrix = [
        [mat_relative[i][j] for j in range(4)] 
        for i in range(4)
    ]

    # Map to your image sequence file path naming convention
    frame_data = {
        "file_path": f"./images/frame_{f:03d}.png",
        "transform_matrix": transform_matrix
    }
    output_data["frames"].append(frame_data)

output_path = bpy.path.abspath("//transforms.json")
with open(output_path, "w") as outfile:
    json.dump(output_data, outfile, indent=4)

print(f"Successfully exported relative camera poses to: {output_path}")
