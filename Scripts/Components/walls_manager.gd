@tool
extends Node3D
class_name WallsManager

@export var wall_material : Material
@export var entrance_material : Material

var _trfm : HexCoord
var _height : int

func setup(trfm : HexCoord, height : int):
	self._trfm = trfm
	self._height = height

func generate():
	if not wall_material:
		wall_material = StandardMaterial3D.new()
	
	var colors = [Color.DARK_RED, Color.DARK_GREEN, Color.DARK_BLUE, Color.DARK_GOLDENROD, Color.DARK_MAGENTA, Color.DARK_CYAN]
	for dir in range(EnumTypes.Direction.keys().size()):
		var wall : MeshInstance3D = _create_wall(dir, colors.get(dir))
		self.add_child(wall)
		wall.owner = get_tree().edited_scene_root
	

func _create_wall(direction : int, color : Color) -> MeshInstance3D:
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
	material.albedo_color = color
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array.set(Mesh.ARRAY_VERTEX, vertices)
	array.set(Mesh.ARRAY_INDEX, indices)
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	wall.mesh = mesh
	
	return wall
	
