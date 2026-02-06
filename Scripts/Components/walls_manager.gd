extends Node3D
class_name WallsManager

@export var wall_material : Material
@export var entrance_material : Material

var _trfm : HexCoord
var _height : int
var _required_entrancies : Array[EnumTypes.Direction]

func setup(trfm : HexCoord, height : int):
	self._trfm = trfm
	self._height = height

func generate(gallery_seed : int, required_entrancies : Array[EnumTypes.Direction]):
	self._required_entrancies = required_entrancies
	
	if not wall_material:
		wall_material = StandardMaterial3D.new()
	
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
	
	var material = wall_material.duplicate(true)
	if material is StandardMaterial3D:
		material.albedo_color = color
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array.set(Mesh.ARRAY_VERTEX, vertices)
	array.set(Mesh.ARRAY_INDEX, indices)
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	wall.mesh = mesh
	
	return wall
	
