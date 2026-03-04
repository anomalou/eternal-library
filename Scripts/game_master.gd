extends Node
class_name GameMaster

@onready var _game_session_pref : PackedScene = load("res://Scenes/GameSession.tscn")

func _ready() -> void:
	start_new_game()

func start_new_game():
	var game_session = self._game_session_pref.instantiate() as GameSession
	GameEnv.set_current_session(game_session)
	add_child(game_session)
	game_session.set_deferred("owner", self)
	
	var session_config : SessionConfig = SessionConfig.new()
	session_config.name = "New game"
	session_config.master_seed = 124
	session_config.world_density = 0.1
	
	game_session.init(session_config)
	game_session.generate_world()
	game_session.create_player()
