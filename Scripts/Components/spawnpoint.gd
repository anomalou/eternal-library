@tool
extends Marker3D
class_name SpawnPoint

# Only use for marking spawn points, and base transform for entities

@export var spawntable : String
@export var auto_rotate : bool = true
@export var invert_rotate : bool = false
@export_placeholder("None") var spawn_group : String

@export_tool_button("Rotate", "RotateRight") var rotation_button = _rotate_action
@export_tool_button("Center", "ControlAlignCenterTop") var center_button = _center_action

func _process(_delta: float) -> void:
	if auto_rotate:
		_auto_rotate()

func _auto_rotate():
	if not Engine.is_editor_hint():
		return
	
	var spawn_point_manager = get_parent_node_3d()
	if spawn_point_manager:
		if global_position != spawn_point_manager.global_position:
			look_at(spawn_point_manager.global_position, Vector3.UP, true)
			if invert_rotate:
				rotate_y(deg_to_rad(180))

func _rotate_action():
	var base_direction = position
	position = base_direction.rotated(Vector3.UP, deg_to_rad(60))
	Log.info(name, " clockwise rotated for 120 degree")

func _center_action():
	Log.info(name, " centerized")
