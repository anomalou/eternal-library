@tool
extends MeshInstance3D
class_name HexagonGizmo

var _position : HexCoord
var _height : float = 32.0
@export var gizmo_visible : bool = true:
	set(value):
		gizmo_visible = value
		_draw_gizmo()
	get:
		return gizmo_visible

func _ready() -> void:
	_draw_gizmo()

func setup(pos : HexCoord, height : float):
	self._position = pos
	self._height = height
	_draw_gizmo()

func _draw_gizmo():
	if not Engine.is_editor_hint():
		return
	
	if not _position:
		self._position = HexCoord.new(0, 0, 0)
	
	print_debug("Try draw gizmo in position ", _position.to_str(), " with size ", _position.size)
	_draw_armature()
	

func _draw_armature():
	self.mesh = null
	
	if not gizmo_visible:
		return
	
	var _mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	vertices.append(Vector3.ZERO)
	
	for i in range(7):
		var angle = deg_to_rad(60 * i)
		vertices.append(Vector3(
			_position.size * cos(angle),
			0.0,
			_position.size * sin(angle)
		))
	
	var wall_index = vertices.size()
	for i in range(6):
		var angle1 = deg_to_rad(60 * i)
		var angle2 = deg_to_rad(60 * (i + 1))
		vertices.append(Vector3(
			_position.size * cos(angle1),
			0.0,
			_position.size * sin(angle1),
		)) 
		vertices.append(Vector3(
			_position.size * cos(angle1),
			float(_height),
			_position.size * sin(angle1),
		))
		vertices.append(Vector3(
			_position.size * cos(angle2),
			float(_height),
			_position.size * sin(angle2),
		))
		vertices.append(Vector3(
			_position.size * cos(angle2),
			0.0,
			_position.size * sin(angle2)
		))
	
	for i in range(6):
		indices.append(0)
		indices.append(i + 1)
		indices.append(i + 2)
	
	for i in range(6):
		var base_index = wall_index + i * 4
		indices.append(base_index)
		indices.append(base_index + 1)
		indices.append(base_index + 2)
		indices.append(base_index + 3)
		
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.no_depth_test = true
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, array)
	_mesh.surface_set_material(0, material)

	self.mesh = _mesh
