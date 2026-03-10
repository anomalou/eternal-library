extends Config
class_name SpawnTable

@export var spawn_list : Dictionary[int, String] # entity_config_id, spawn_weight

func get_entity_with_rnd(rnd : RandomNumberGenerator) -> String:
	var max_chance : int = spawn_list.keys().reduce(func(a, b): return a + b, 0)
	var chance = rnd.randi_range(0, max_chance)
	var sorted_chances = spawn_list.keys()
	sorted_chances.sort()
	var current_chance = 0
	for spawn_chance in sorted_chances:
		if chance >= current_chance:
			current_chance = spawn_chance
		else:
			break
	return spawn_list.get(current_chance)
