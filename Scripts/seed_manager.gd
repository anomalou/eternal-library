class_name SeedManager

const ROOT = "root"
const SALT = "developed_by_lisko"

const SEP1 = ":"
const SEP2 = "|"
const SEP3 = "_"
const SEP4 = "/"

var seed_cache : Dictionary[String, int]
var rand_cache : Dictionary[String, RandomNumberGenerator]

func _init(_seed : int = 0):
	if _seed == 0:
		generate_root_seed()
	else:
		seed_cache.set(ROOT, _seed)

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
func generate_object_id(object_type : String, context : String = "", parent_id : String = ""):
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
		

func get_rnd(id : String) -> RandomNumberGenerator:
	if not rand_cache.has(id):
		var rnd = RandomNumberGenerator.new()
		rnd.seed = get_seed(id)
		rand_cache.set(id, rnd)
	return rand_cache.get(id)

# always creates new RandomNumberGenerator
func get_temp_rnd(id : String) -> RandomNumberGenerator:
	var rnd = RandomNumberGenerator.new()
	rnd.seed = get_seed(id)
	return rnd

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
