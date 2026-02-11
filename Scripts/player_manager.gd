extends Node
class_name PlayerManager

var player_id : String
var player : CharacterBody3D

var _randomizer : RandomNumberGenerator
var _player_pref : PackedScene

func _init() -> void:
	self._player_pref = load("res://Prefabs/Player.tscn")

func init(_player_id : String, randomizer : RandomNumberGenerator):
	self.player_id = _player_id
	self._randomizer = randomizer

func spawn_player():
	if player:
		push_error("Player allready exists and will not be institated")
		return
	player = _player_pref.instantiate()
	player.name = "Player"
	# randomize player position by seed generator
	add_child(player)
	player.set_deferred("owner", self)
