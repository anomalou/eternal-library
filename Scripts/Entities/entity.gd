@abstract
extends Node3D
class_name Entity

var id : String
var _seed_manager : SeedManager

func _ready() -> void:
	var _session = GameEnv.get_current_session() as GameSession
	if _session:
		self._seed_manager = _session.seed_manager
	else:
		push_error("Entity initialization without game session!")
