extends Node3D
class_name Portal

@onready var head : Node3D = $SubViewport/Head
@onready var camera : Camera3D = $SubViewport/Head/Camera3D
@onready var viewport : SubViewport = $SubViewport

@export var shader : ShaderMaterial
var texture : Texture

var hex : HexCoord = HexCoord.new()
var height : float = 32

func _ready() -> void:
	Signals.player_move.connect(_move_camera)
	
	texture = viewport.get_texture()
	
	var wall = _create_wall(EnumTypes.Direction.NW)
	add_child(wall)
	wall.set_deferred("owner", self)

func _move_camera(_position : Vector3, view : Vector2):
	head.position = _position + Vector3(0, 0, -25)
	camera.rotation = Vector3(view.x, 0, 0)
	head.rotation = Vector3(0, view.y, 0)

func _create_wall(direction : EnumTypes.Direction, color : Color = Color.WHITE) -> MeshInstance3D:
	var wall : MeshInstance3D = MeshInstance3D.new()
	
	var mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	var uv = PackedVector2Array()
	
	var angle1 = deg_to_rad(60 * direction)
	var angle2 = deg_to_rad(60 * (direction + 1))
	
	vertices.append(Vector3(hex.size * cos(angle1), 0.0, hex.size * sin(angle1)))
	vertices.append(Vector3(hex.size * cos(angle1), height, hex.size * sin(angle1)))
	vertices.append(Vector3(hex.size * cos(angle2), 0.0, hex.size * sin(angle2)))
	vertices.append(Vector3(hex.size * cos(angle2), height, hex.size * sin(angle2)))
	
	indices.append_array([0, 1, 2])
	indices.append_array([2, 1, 3])
	
	uv.append(Vector2(0, 1))
	uv.append(Vector2(0, 0))
	uv.append(Vector2(1, 1))
	uv.append(Vector2(1, 0))
	
	var material = shader.duplicate(true)
	if material is ColorShader:
		material.set_color(color)
	elif material is TextureShader:
		material.set_texture(texture)
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array.set(Mesh.ARRAY_VERTEX, vertices)
	array.set(Mesh.ARRAY_INDEX, indices)
	array.set(Mesh.ARRAY_TEX_UV, uv)
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	wall.mesh = mesh
	
	return wall

func update_portal_camera():
	# Данные
	var player_camera = get_viewport().get_camera_3d()
	var portal_plane = $PortalPlane
	var target_room = $TargetRoom
	var portal_camera = $PortalCamera
	
	# 1. Позиция в локальных координатах портала
	var to_player = player_camera.global_position - portal_plane.global_position
	var local_pos = portal_plane.global_transform.basis.inverse() * to_player
	
	# 2. Отражаем позицию
	var reflected_pos = Vector3(-local_pos.x, local_pos.y, -local_pos.z)
	
	# 3. Находим точку назначения (центр портала в целевой комнате)
	var target_portal = target_room.get_node("PortalExit")
	var target_transform = target_portal.global_transform
	
	# 4. Позиция камеры портала
	portal_camera.global_position = target_transform.origin + target_transform.basis * reflected_pos
	
	# 5. Направление взгляда
	var player_view = player_camera.global_transform.basis.z
	var local_view = portal_plane.global_transform.basis.inverse() * player_view
	var reflected_view = Vector3(-local_view.x, local_view.y, -local_view.z)
	var global_view = target_transform.basis * reflected_view
	
	# 6. Поворот камеры
	portal_camera.global_transform.basis = Basis.looking_at(global_view, Vector3.UP)
