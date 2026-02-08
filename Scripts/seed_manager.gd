extends Node

const ROOT = "root"
const SALT = "developed_by_lisko"

const SEP1 = ":"
const SEP2 = "|"
const SEP3 = "_"
const SEP4 = "/"

var seed_cache : Dictionary[String, int]
var rand_cache : Dictionary[String, RandomNumberGenerator]

func get_root_seed():
	if not seed_cache.has(ROOT):
		generate_root_seed()
	return seed_cache.get(ROOT)

func generate_root_seed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var root_seed = rng.randi() ^ hash(SALT)
	print_debug("Generated root seed = ", root_seed)
	seed_cache.set(ROOT, root_seed)

# also creates seed for this object
func generate_object_id(parent_id : String, object_type : String, object : Object):
	if not object.has_method("context"):
		push_error("Cant create id for object type ", object_type, " it not have context method")
	var context = object.call("context")
	if parent_id == null or parent_id.is_empty():
		parent_id = ROOT
	var parent_seed = get_seed(parent_id)
	var id_hash = hash(str(parent_seed) + SEP3 + object_type + SEP3 + context)
	var object_id = parent_id + SEP4 + object_type + SEP3 + str(id_hash)
	_generate_seed(object_id)
	return object_id

func get_seed(id : String):
	if id.is_empty():
		return get_root_seed()
	if seed_cache.has(id):
		return seed_cache.get(id)
	
	_generate_seed(id)
	return seed_cache.get(id, get_root_seed())
		

func _generate_seed(id : String):
	var parent_id = LibraryUtils.get_parent_id(id)
	if LibraryUtils.ID_ERROR == parent_id or id.is_empty():
		push_error("Provided incorrect id, seed will not be generated")
		return
	else:
		var parent_seed = get_seed(parent_id)
		var h1 = hash(str(parent_seed) + SEP1 + id)
		var h2 = hash(id + SEP2 + str(parent_seed))
		var h = h1 ^ h2
		seed_cache.set(id, h)
		print_debug("Seed ", str(h), " for ", id, " generated")


# id looks like "world/gallery_1/bookshell_1/book_1"
#func get_seed(object_id : String) -> int:
	#if seed_cache.has(object_id):
		#return seed_cache.get(object_id)
	#
	#var parent_key : String
	#var parts = object_id.split(SEP2) as Array
	#parts.pop_back()
	#if parts.is_empty():
		#parent_key = object_id
	#else:
		#parent_key = "/".join(parts)
	#
	#var parent_seed : int
	#if seed_cache.has(parent_key):
		#parent_seed = seed_cache.get(parent_key)
	#else:
		#parent_seed = generate_world_seed()
	#
	#if not seed_cache.has(parent_id):
		#parent_seed = world_seed
	#else:
		#parent_seed = seed_cache.get(parent_id)
	#
	#var h1 = hash(str(parent_seed) + SEP1 + seed_key)
	#var h2 = hash(seed_key + SEP2 + str(parent_seed) + "_yep_im_here_just_for_your_questions_>:|")
	#
	#var h = h1 ^ h2
	
	
	

#func get_system_seed(system_name : EnumTypes.SystemType) -> int:
	#if not world_seed:
		#generate_world_seed()
	#
	#var str_system_name = EnumTypes.system_to_str(system_name)
	#
	#if system_seed_cache.has(system_name):
		#var system_seed = system_seed_cache.get(system_name, world_seed)
		#print_debug("Found system " + str_system_name + " seed from cache ", system_seed)
		#return system_seed
	#
	#var h1 = hash(str(world_seed) + SEP1 + str_system_name)
	#var h2 = hash(str_system_name + SEP2 + str(world_seed))
	#
	#var h = h1 ^ h2
	#print_debug("System ", system_name, " seed generated = ", h)
	#system_seed_cache.set(system_name, h)
	#
	#return h

#func get_entity_seed(system_name : EnumTypes.SystemType, entity_name : String) -> int:
	#var str_system_name = EnumTypes.system_to_str(system_name)
	#var seed_key = str_system_name + "_" + entity_name
	#if entities_seed_cache.has(seed_key):
		#var entity_seed = entities_seed_cache.get(seed_key)
		#print_debug("Found seed ", entity_seed, " for entity ", seed_key)
		#return entity_seed
	#
	#var system_seed = get_system_seed(system_name)
	#
	#var h1 = hash(str(world_seed) + SEP1 + str(system_seed) + SEP1 + entity_name)
	#var h2 = hash(str(system_seed) + SEP2 + str(world_seed) + SEP2 + entity_name)
	#var h3 = hash(entity_name + SEP3 + str(system_seed) + SEP3 + str(world_seed) + "_yep_im_here_just_for_your_questions_>:|")
	#
	#var h = h1 ^ h2 ^ h3
	#print_debug("Entity ", seed_key, " seed = ", h)
	#entities_seed_cache.set(seed_key, h)
	#
	#return h
