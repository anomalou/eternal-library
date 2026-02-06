extends Node3D
class_name FloorManager

@export var floor_material : Material
@export var ceil_material : Material

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
	
	add_child(_floor)
	add_child(_ceil)
	_floor.set_deferred("owner", self)
	_ceil.set_deferred("owner", self)

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
	return hex
