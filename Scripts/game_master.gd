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
	
	game_session.init_subsystems(1234)
	game_session.generate_world()
	game_session.create_player()
