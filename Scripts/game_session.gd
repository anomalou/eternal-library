extends Node
class_name GameSession

@onready var seed_manager : SeedManager = $SeedManager
@onready var entity_manager : EntityManager = $EntityManager
@onready var world_generator : WorldGenerator = $WorldGenerator
@onready var player_manager : PlayerManager = $PlayerManager

var _config : SessionConfig

# only for caches and outher managers initialization
func init(config : SessionConfig):
	self._config = config
	
	seed_manager.init(config.master_seed)
	entity_manager.init()
	world_generator.init(config, seed_manager, entity_manager)
	player_manager.init(seed_manager)

# call only when game session exists on game scene
func generate_world():
	world_generator.generate_in_range(HexCoord.new(), 1)

func create_player():
	player_manager.spawn_player()
