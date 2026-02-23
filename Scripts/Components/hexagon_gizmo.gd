@tool
extends MeshInstance3D
class_name HexagonGizmo

var _size : float = 32.0
var _height : float = 32.0
@export var gizmo_visible : bool = true:
	set(value):
		gizmo_visible = value
		_draw_gizmo()
	get:
		return gizmo_visible

@export_tool_button("Rebuild") var rebuild_action = _draw_gizmo


func _ready() -> void:
	_draw_gizmo()

func _draw_gizmo():
	print_debug("Start gizmo drawing")
	if not Engine.is_editor_hint():
		return
	
	var _config = load(Constants.get_value("hexagon_config")) as HexagonConfig
	_size = _config.size
	_height = _config.height
	
	print_debug("Try draw gizmo with size ", _size)
	_draw_armature()
	

func _draw_armature():
	self.mesh = null
	
	if not gizmo_visible:
		return
	
	var _mesh = ArrayMesh.new()
	
	var _floor : Array = _get_floor()
	
	var floor_material = StandardMaterial3D.new()
	floor_material.albedo_color = Color(Color.DARK_GRAY, 0.5)
	floor_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	floor_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	floor_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _floor)
	_mesh.surface_set_material(0, floor_material)
	
	var colors = [Color.DARK_RED, Color.DARK_GREEN, Color.DARK_BLUE, Color.DARK_GOLDENROD, Color.DARK_MAGENTA, Color.DARK_CYAN]
	for i in range(6):
		var wall = _get_wall(i)
		
		var wall_material = StandardMaterial3D.new()
		wall_material.albedo_color = Color(colors.get(i), 0.5)
		wall_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		wall_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		wall_material.cull_mode = BaseMaterial3D.CULL_DISABLED
		
		_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, wall)
		_mesh.surface_set_material(1 + i, wall_material)

	self.mesh = _mesh

func _get_floor() -> Array:
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	vertices.append(Vector3.ZERO)
	
	for i in range(7):
		var angle = deg_to_rad(60 * i)
		vertices.append(Vector3(
			_size * cos(angle),
			0.0,
			_size * sin(angle)
		))
	
	for i in range(6):
		indices.append(0)
		indices.append(i + 1)
		indices.append(i + 2)
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	
	return array

func _get_wall(direction : int) -> Array:
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var angle1 = deg_to_rad(60 * direction)
	var angle2 = deg_to_rad(60 * (direction + 1))
	vertices.append(Vector3(
		_size * cos(angle1),
		0.0,
		_size * sin(angle1),
	))
	vertices.append(Vector3(
		_size * cos(angle1),
		float(_height),
		_size * sin(angle1),
	))
	vertices.append(Vector3(
		_size * cos(angle2),
		float(_height),
		_size * sin(angle2),
	))
	vertices.append(Vector3(
		_size * cos(angle2),
		0.0,
		_size * sin(angle2)
	))
	
	indices.append_array([0, 1, 3])
	indices.append_array([1, 2, 3])
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	
	return array
