@abstract
extends Node3D
class_name GameObject

var id : String
var _seed_manager : SeedManager
var _entity_manager : EntityManager

func _ready() -> void:
	var _session = GameEnv.get_current_session() as GameSession
	if _session:
		self._seed_manager = _session.seed_manager
		self._entity_manager = _session.entity_manager
	else:
		push_error("Entity initialization without game session!")
