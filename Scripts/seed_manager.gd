extends Node
class_name SeedManager

var world_seed : int
var system_seed_cache : Dictionary

func _ready() -> void:
	generate_world_seed()
	generate_system_seed("galeries")
	generate_system_seed("books")
	generate_system_seed("quests")
	pass

func generate_world_seed():
	world_seed = hash(int(Time.get_unix_time_from_system()) ^ Time.get_ticks_usec())
	print_debug("Generated world seed = ", world_seed)

func generate_system_seed(system_name : String) -> int:
	if system_seed_cache.has(system_name):
		var system_seed = system_seed_cache.get(system_name, world_seed)
		print_debug("Found system " + system_name + " seed from cache ", system_seed)
		return system_seed
	
	if not world_seed:
		generate_world_seed()
	var h1 = hash(str(world_seed) + ":" + system_name)
	var h2 = hash(system_name + "/" + str(world_seed))
	
	var h = h1 ^ h2
	print_debug("System ", system_name, " seed generated = ", h)
	system_seed_cache.set(system_name, h)
	
	return h
		
