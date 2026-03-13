extends Config
class_name SpawnTable

@export var spawn_list : Dictionary[String, int] # entity_config_id, spawn_weight

func get_entity_with_rnd(rnd : RandomNumberGenerator) -> String:
	var max_chance : int = spawn_list.values().reduce(func(a, b): return a + b, 0)
	var chance = rnd.randi_range(0, max_chance)
	var sorted_chances = spawn_list.values()
	sorted_chances.sort()
	var current_chance = 0
	for spawn_chance in sorted_chances:
		if chance >= current_chance:
			current_chance = spawn_chance
		else:
			break
	return spawn_list.find_key(current_chance)
