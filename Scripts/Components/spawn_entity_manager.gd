@tool
extends Component
class_name SpawnEntityManager

@warning_ignore("unused_private_class_variable")
@export_tool_button("Create spawnpoint", "Marker3D") var _create_spawnpoint_action = _create_spawnpoint

@export var _spawnpoint : PackedScene

func _create_spawnpoint():
	var spawnpoint = _spawnpoint.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) as SpawnPoint
	spawnpoint.name = "Spawnpoint" + str(get_child_count())
	self.add_child(spawnpoint, InternalMode.INTERNAL_MODE_DISABLED)
	spawnpoint.owner = get_tree().edited_scene_root
	Log.info("Spawnpoint created")

func generate(_id : String):
	self.id = _id
	var spawnpoints : Array[SpawnPoint] = []
	spawnpoints.assign(get_children().filter(func(e): return e is SpawnPoint))
	for spawnpoint in spawnpoints:
		var spawntable : SpawnTable = SpawnTableManager.get_by_id(spawnpoint.spawntable)
		var spawnpoint_id = _seed_manager.generate_object_id("spawnpoint", spawnpoint.name, id)
		var rnd = _seed_manager.get_rnd(spawnpoint_id)
		var max_chance : int = spawntable.spawn_list.keys().reduce(func(a, b): return a + b, 0)
		var chance = rnd.randi_range(0, max_chance)
		var sorted_chances = spawntable.spawn_list.keys()
		sorted_chances.sort()
		var current_chance = 0
		for spawn_chance in sorted_chances:
			if chance >= current_chance:
				current_chance = spawn_chance
			else:
				break
		var entity = spawntable.spawn_list.get(current_chance)
		_spawn_entity(entity, spawnpoint_id, spawnpoint)
		await get_tree().process_frame

func _spawn_entity(entity_name : String, spawnpoint_id : String, spawnpoint : SpawnPoint):
	var entity_id = _seed_manager.generate_object_id("entity", entity_name, spawnpoint_id)
	var entity : Entity = _entity_manager.create_entity(entity_id, entity_name, spawnpoint)

	
