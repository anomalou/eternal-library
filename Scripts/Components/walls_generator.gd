extends Node3D
class_name WallsGenerator

@export var wall_shader : ShaderMaterial

@export_flags_3d_physics var collision_layers : int
@export_flags_3d_physics var collision_mask : int
@export var thickness : float

var _gallery_id : String
var _trfm : HexCoord
var _height : int
var _required_entrancies : Array[EnumTypes.Direction]

func setup(id : String, trfm : HexCoord, height : int):
	self._gallery_id = id
	self._trfm = trfm
	self._height = height

func generate(required_entrancies : Array[EnumTypes.Direction]):
	self._required_entrancies = required_entrancies
	
	if not wall_shader:
		push_error("Wall shader not set up")
		return
	
	var colors = [Color.DARK_RED, Color.DARK_GREEN, Color.DARK_BLUE, Color.DARK_GOLDENROD, Color.DARK_MAGENTA, Color.DARK_CYAN]
	var directions = EnumTypes.Direction.values()
	for dir in directions:
		if dir not in self._required_entrancies:
			var wall : MeshInstance3D = _create_wall(dir, colors.get(dir))
			self.add_child(wall)
			wall.set_deferred("owner", self)
	

func _create_wall(direction : EnumTypes.Direction, color : Color = Color.WHITE) -> MeshInstance3D:
	var wall : MeshInstance3D = MeshInstance3D.new()
	
	var mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var angle1 = deg_to_rad(60 * direction)
	var angle2 = deg_to_rad(60 * (direction + 1))
	
	vertices.append(Vector3(_trfm.size * cos(angle1), 0.0, _trfm.size * sin(angle1)))
	vertices.append(Vector3(_trfm.size * cos(angle1), _height, _trfm.size * sin(angle1)))
	vertices.append(Vector3(_trfm.size * cos(angle2), 0.0, _trfm.size * sin(angle2)))
	vertices.append(Vector3(_trfm.size * cos(angle2), _height, _trfm.size * sin(angle2)))
	
	indices.append_array([0, 1, 2])
	indices.append_array([2, 1, 3])
	
	var material = wall_shader.duplicate(true) as ColorShader
	material.set_color(color)
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array.set(Mesh.ARRAY_VERTEX, vertices)
	array.set(Mesh.ARRAY_INDEX, indices)
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	wall.mesh = mesh
	
	_create_wall_collision(wall, direction)
	
	return wall


func _create_wall_collision(wall : MeshInstance3D, direction : EnumTypes.Direction) -> StaticBody3D:
	var static_body = StaticBody3D.new()
	static_body.collision_layer = collision_layers
	static_body.collision_mask = collision_mask
	
	var collision_shape = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	var angle = deg_to_rad(60 * direction + 30)
	
	var center_x = _trfm.size * cos(deg_to_rad(30)) * cos(angle)
	var center_z = _trfm.size * cos(deg_to_rad(30)) * sin(angle)
	var center_y = _height / 2.0
	
	shape.size = Vector3(_trfm.size, _height, thickness)
	
	collision_shape.shape = shape
	collision_shape.position = Vector3(center_x, center_y, center_z)
	
	collision_shape.rotation.y = deg_to_rad(60 + 120 * direction)
	
	static_body.add_child(collision_shape)
	wall.add_child(static_body)
	collision_shape.set_deferred("owner", static_body)
	static_body.set_deferred("owner", wall)
	
	return static_body
	
