@tool
extends Component
class_name SpawnPointManager

@warning_ignore("unused_private_class_variable")
@export_tool_button("Create spawnpoint", "Marker3D") var _create_spawnpoint_action = _create_spawnpoint

var _spawnpoint : PackedScene

func _ready() -> void:
	_spawnpoint = load("res://Components/SpawnPoint.tscn")

func _create_spawnpoint():
	var spawnpoint = _spawnpoint.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) as SpawnPoint
	spawnpoint.name = "Spawnpoint" + str(get_child_count())
	spawnpoint.gizmo_extents = 1.0
	self.add_child(spawnpoint, InternalMode.INTERNAL_MODE_DISABLED)
	spawnpoint.owner = get_tree().edited_scene_root
	print_debug("Spawnpoint created")

func get_spawpoint_list() -> Array[SpawnPoint]:
	return get_children() as Array[SpawnPoint]
