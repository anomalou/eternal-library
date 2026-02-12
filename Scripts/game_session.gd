extends Node
class_name GameSession

var seed_manager : SeedManager
var entity_manager : EntityManager

@onready var _world_manager : WorldManager = $WorldManager
@onready var _player_manager : PlayerManager = $PlayerManager

# only for caches and outher managers initialization
func init_subsystems(_seed : int = 0):
	seed_manager = SeedManager.new(_seed)
	entity_manager = EntityManager.new()
	
	_world_manager.init(self)
	var player_id = seed_manager.generate_object_id("player")
	_player_manager.init(player_id, seed_manager.get_rnd(player_id))

# call only when game session exists on game scene
func generate_world():
	_world_manager.generate_world()

func create_player():
	_player_manager.spawn_player()
