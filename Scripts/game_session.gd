extends Node
class_name GameSession

@onready var seed_manager : SeedManager = $SeedManager
@onready var entity_manager : EntityManager = $EntityManager
@onready var world_manager : WorldManager = $WorldManager
@onready var player_manager : PlayerManager = $PlayerManager

# only for caches and outher managers initialization
func init_subsystems(_seed : int = 0):
	seed_manager.init(_seed)
	entity_manager.init()
	world_manager.init(self)
	var player_id = seed_manager.generate_object_id("player")
	player_manager.init(player_id, seed_manager.get_rnd(player_id))

# call only when game session exists on game scene
func generate_world():
	world_manager.generate_in_range(HexCoord.new(), 3)

func create_player():
	player_manager.spawn_player()
