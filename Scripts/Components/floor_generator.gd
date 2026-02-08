extends Node3D
class_name FloorGenerator

@export var floor_material : Material
@export var ceil_material : Material

@export_flags_3d_physics var collision_layers : int
@export_flags_3d_physics var collision_mask : int

var _position : HexCoord
var _height : int

func setup(pos : HexCoord, height : int):
	self._position = pos
	self._height = height

func generate():
	if not self.floor_material:
		self.floor_material = StandardMaterial3D.new()
	if not self.ceil_material:
		self.ceil_material = StandardMaterial3D.new()
	
	var _floor = _generate_hex(self.floor_material, 0, Color.DIM_GRAY) as MeshInstance3D
	var _ceil = _generate_hex(self.ceil_material, self._height, Color.DEEP_SKY_BLUE, false) as MeshInstance3D
	_generate_collision_for_hex(_floor)

func _generate_hex(material : Material, height : int = 0, color : Color = Color.WHITE, clockwise : bool = true) -> MeshInstance3D:
	var hex = MeshInstance3D.new()
	
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	vertices.append(Vector3(0, height, 0))
	
	for i in range(7):
		var angle = deg_to_rad(60 * i)
		vertices.append(Vector3(
			_position.size * cos(angle),
			height,
			_position.size * sin(angle)
		))
	
	for i in range(6):
		if clockwise:
			indices.append(0)
			indices.append(i + 1)
			indices.append(i + 2)
		else:
			indices.append(i + 2)
			indices.append(i + 1)
			indices.append(0)
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	
	var _material = material.duplicate(true)
	if _material is StandardMaterial3D:
		_material.albedo_color = color
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, _material)
	
	hex.mesh = mesh
	
	add_child(hex)
	hex.set_deferred("owner", self)
	
	return hex

func _generate_collision_for_hex(hex : MeshInstance3D) -> StaticBody3D:
	var static_body = StaticBody3D.new()
	
	static_body.collision_layer = collision_layers
	static_body.collision_mask = collision_mask
	
	var collision_shape = CollisionShape3D.new()
	var shape = hex.mesh.create_trimesh_shape()
	if shape:
		collision_shape.shape = shape
		static_body.add_child(collision_shape)
		hex.add_child(static_body)
		static_body.set_deferred("owner", hex)
		collision_shape.set_deferred("owner", static_body)
		
		print_debug("Collision for hex ", hex, " created")
		return static_body
	else:
		push_error("Cant create collision for hex ", hex)
		static_body.queue_free()
		return null
