@abstract
extends Component
class_name FloorGenerator

@export_flags_3d_physics var collision_layers : int
@export_flags_3d_physics var collision_mask : int

func _generate_collider(mesh : MeshInstance3D):
	var static_body = StaticBody3D.new()
	static_body.collision_layer = collision_layers
	static_body.collision_mask = collision_mask
	
	var collision_shape = CollisionShape3D.new()
	var shape = mesh.mesh.create_trimesh_shape()
	if shape:
		collision_shape.shape = shape
		mesh.add_child(static_body)
		static_body.add_child(collision_shape)
		static_body.set_deferred("owner", mesh)
		collision_shape.set_deferred("owner", static_body)
		
		print_debug("Corridor floor collision generated")
	else:
		static_body.queue_free()
		push_error("Failed corridor floor collision shape creation")
