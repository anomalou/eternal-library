@tool
extends Marker3D
class_name SpawnPoint

# Only use for marking spawn points, and base transform for entities

@export var allowed_spawnlist : Dictionary[String, int] # spawn_table_id, select_weight
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
