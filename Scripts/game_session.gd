extends Node
class_name GameSession

@onready var seed_manager : SeedManager = $SeedManager
@onready var entity_manager : EntityManager = $EntityManager
@onready var world_generator : WorldGenerator = $WorldGenerator
@onready var player_manager : PlayerManager = $PlayerManager
@onready var book_manager : BookManager = $BookManager
@onready var book_controller : BookController = $BookController

var _config : SessionConfig

# only for caches and outher managers initialization
func init(config : SessionConfig):
	self._config = config
	
	seed_manager.init(config.master_seed)
	entity_manager.init()
	world_generator.init(config, seed_manager, entity_manager)
	player_manager.init(seed_manager)
	book_manager.init(seed_manager)
	book_controller.init(entity_manager, book_manager)

# call only when game session exists on game scene
func generate_world():
	world_generator.generate_in_range(HexCoord.new(), 2)

func create_player():
	player_manager.spawn_player()
	var journal_id = book_manager.generate_player_journal(player_manager.player_id)
	var book : Entity = entity_manager.create_entity(journal_id, "book")
	#book.rotate_x(deg_to_rad(90))
	book.position = Vector3(0, 5.3, -9.0)
	
	Signals.select_book.emit(journal_id)
