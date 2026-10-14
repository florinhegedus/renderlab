import bpy


scene = bpy.scene if hasattr(bpy, "scene") else bpy.context.scene
scene.render.engine = "CYCLES"

# Force GPU Acceleration (OptiX / CUDA / Metal)
try:
  cycles_prefs = bpy.context.preferences.addons["cycles"].preferences
  cycles_prefs.compute_device_type = "OPTIX"
  cycles_prefs.get_devices()
  for device in cycles_prefs.devices:
    if device.type in {"CUDA", "OPTIX", "HIP", "METAL"}:
      device.use = True
except Exception as e:
  print(
      f"Warning: Could not configure GPU compute automatically. Using default"
      f" device. Details: {e}"
  )

scene.cycles.device = "GPU"
scene.cycles.samples = 128  # Lower for speed, increase for higher quality
scene.cycles.use_adaptive_sampling = True
scene.cycles.adaptive_threshold = 0.01

scene.cycles.max_bounces = 4
scene.cycles.diffuse_bounces = 2
scene.cycles.glossy_bounces = 1
scene.cycles.transparent_max_bounces = 4

scene.render.use_persistent_data = True

scene.render.image_settings.file_format = "PNG"
scene.render.image_settings.color_mode = "RGBA"
scene.render.film_transparent = (
    False  # Transparent background mask out-of-the-box
)

output_dir = "//dataset/images/"

for i in range(scene.frame_start, scene.frame_end + 1):
  scene.frame_set(i)
  bpy.context.view_layer.update()

  # Set path and render frame
  frame_filename = f"frame_{i:03d}.png"
  scene.render.filepath = bpy.path.abspath(f"{output_dir}{frame_filename}")

  print(f"Rendering frame {i+1}/{scene.frame_end + 1}")
  bpy.ops.render.render(write_still=True)

print("Rendering complete!")
