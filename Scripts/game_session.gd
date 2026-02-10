extends Node
class_name GameSession

var seed_manager : SeedManager
var entity_manager : EntityManager

@onready var _world_generator = $WorldGenerator

# only for caches and outher
func create(_seed : int = 0):
	seed_manager = SeedManager.new(_seed)
	entity_manager = EntityManager.new()

# call only when game session exists on game scene
func generate_world():
	_world_generator.generate_world()
