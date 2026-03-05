@tool
extends Marker3D
class_name SpawnPoint

var id : String

@export var spawnlist : Dictionary[EnumTypes.EntityType, float]
@export var auto_rotate : bool = true

func _process(_delta: float) -> void:
	if auto_rotate:
		_auto_rotate()

func _auto_rotate():
	if not Engine.is_editor_hint():
		return
	
	var spawn_point_manager = get_parent_node_3d()
	if spawn_point_manager:
		look_at(spawn_point_manager.global_position, Vector3.UP, true)
