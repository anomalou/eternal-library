extends Node
class_name PlayerManager

var player_id : String
var player : CharacterBody3D
var player_room : HexCoord # current room player visiting

var _randomizer : RandomNumberGenerator
var _player_pref : PackedScene

func _init() -> void:
	self._player_pref = load("res://Prefabs/Player.tscn")
	Signals.player_enter_gallery.connect(debug_player_room)

func _process(_delta):
	if not player:
		return # player not exists so no need to calculate
	
	var player_position = player.global_position
	var room_position = player_room.global_coord
	
	var current_distance = player_position.distance_to(room_position)
	if current_distance > (player_room.size * sqrt(3) / 2 + player_room.spacing * 0.75):
		var min_distance = current_distance
		var closest_room : HexCoord = player_room
		for neigh in player_room.neighbours():
			var dist = player_position.distance_to(neigh.global_coord)
			if dist < min_distance:
				min_distance = dist
				closest_room = neigh
		Signals.player_enter_gallery.emit(player_room, closest_room)
		player_room = closest_room

func debug_player_room(from : HexCoord, to : HexCoord):
	var distance_from = player.global_position.distance_to(from.global_coord)
	var distance_to = player.global_position.distance_to(to.global_coord)
	print_debug("Player moved from ", from.to_str(), " to ", to.to_str())
	print_debug("Distance from ", distance_from, ", distance to ", distance_to)

func init(_player_id : String, randomizer : RandomNumberGenerator):
	self.player_id = _player_id
	self._randomizer = randomizer

func spawn_player():
	if player:
		push_error("Player allready exists and will not be institated")
		return
	player = _player_pref.instantiate()
	player.name = "Player"
	add_child(player)
	player.set_deferred("owner", self)
	# randomize player position by seed generator (but for now it will be ZERO
	player_room = HexCoord.new()
	player.position = player_room.global_coord
	player.position += Vector3(0, 6, 0)
