extends Node
class_name SeedManager

const SALT = "developed_by_lisko"
const SEP1 = ":"
const SEP2 = "/"
const SEP3 = "|"

var world_seed : int
var system_seed_cache : Dictionary
var entities_seed_cache : Dictionary

func _ready() -> void:
	generate_world_seed()
	get_system_seed(EnumTypes.SystemType.GALLERY_LAYOUT)
	get_system_seed(EnumTypes.SystemType.GALLERY)
	pass

func generate_world_seed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	world_seed = rng.randi() ^ hash(SALT)
	print_debug("Generated world seed = ", world_seed)

func get_system_seed(system_name : EnumTypes.SystemType) -> int:
	if not world_seed:
		generate_world_seed()
	
	var str_system_name = EnumTypes.system_to_str(system_name)
	
	if system_seed_cache.has(system_name):
		var system_seed = system_seed_cache.get(system_name, world_seed)
		print_debug("Found system " + str_system_name + " seed from cache ", system_seed)
		return system_seed
	
	var h1 = hash(str(world_seed) + SEP1 + str_system_name)
	var h2 = hash(str_system_name + SEP2 + str(world_seed))
	
	var h = h1 ^ h2
	print_debug("System ", system_name, " seed generated = ", h)
	system_seed_cache.set(system_name, h)
	
	return h

func get_entity_seed(system_name : EnumTypes.SystemType, entity_name : String) -> int:
	var str_system_name = EnumTypes.system_to_str(system_name)
	var seed_key = str_system_name + "_" + entity_name
	if entities_seed_cache.has(seed_key):
		var entity_seed = entities_seed_cache.get(seed_key)
		print_debug("Found seed ", entity_seed, " for entity ", seed_key)
		return entity_seed
	
	var system_seed = get_system_seed(system_name)
	
	var h1 = hash(str(world_seed) + SEP1 + str(system_seed) + SEP1 + entity_name)
	var h2 = hash(str(system_seed) + SEP2 + str(world_seed) + SEP2 + entity_name)
	var h3 = hash(entity_name + SEP3 + str(system_seed) + SEP3 + str(world_seed) + "_yep_im_here_just_for_your_questions_>:|")
	
	var h = h1 ^ h2 ^ h3
	print_debug("Entity ", seed_key, " seed = ", h)
	entities_seed_cache.set(seed_key, h)
	
	return h
