import bpy

# Set the rendering engine to Eevee
bpy.context.scene.render.engine = "BLENDER_EEVEE"

# Set the output file path
output_path = "/tmp/test_render_eevee.png"
bpy.context.scene.render.filepath = output_path

# Configure Eevee settings (optional)
bpy.context.scene.eevee.taa_render_samples = 64
bpy.context.scene.eevee.use_bloom = True

# Clear the existing scene (optional)
bpy.ops.wm.read_factory_settings(use_empty=True)

# Add a cube
bpy.ops.mesh.primitive_cube_add(size=2, location=(0, 0, 0))

# Add a camera
bpy.ops.object.camera_add(location=(5, -5, 5))
camera = bpy.context.object
camera.rotation_euler = (1.1, 0, 0.785)  # Set the camera angle
bpy.context.scene.camera = camera

# Add a light
bpy.ops.object.light_add(type="POINT", location=(0, 0, 5))

# Set render resolution
bpy.context.scene.render.resolution_x = 1920
bpy.context.scene.render.resolution_y = 1080
bpy.context.scene.render.resolution_percentage = 100

# Perform the render
bpy.ops.render.render(write_still=True)

print(f"Render completed. Output saved to: {output_path}")
