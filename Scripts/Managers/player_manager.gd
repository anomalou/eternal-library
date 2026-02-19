extends Node
class_name PlayerManager

var player_id : String
var player : PlayerTest
var player_galley : HexCoord # current gallery player visiting

var _randomizer : RandomNumberGenerator
var _player_pref : PackedScene

func _init() -> void:
	self._player_pref = load("res://Prefabs/Player.tscn")
	Signals.player_enter_gallery.connect(debug_player_room)

func _process(_delta):
	_calculate_player_transition()

func _physics_process(_delta: float) -> void:
	if player:
		Signals.player_move.emit(player.position, Vector2(player.look_x, player.look_y))

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
	player_galley = HexCoord.new()
	player.position = player_galley.global_coord
	player.position += Vector3(0, 6, 0)

func _calculate_player_transition():
	if not player:
		return # player not exists so no need to calculate
	
	var player_position = player.global_position
	var room_position = player_galley.global_coord
	
	var current_distance = player_position.distance_to(room_position)
	if current_distance > (player_galley.size * sqrt(3) / 2 + player_galley.spacing * 0.75):
		var min_distance = current_distance
		var closest_gallery : HexCoord = player_galley
		for neigh in player_galley.neighbours():
			var dist = player_position.distance_to(neigh.global_coord)
			if dist < min_distance:
				min_distance = dist
				closest_gallery = neigh
		Signals.player_enter_gallery.emit(player_galley, closest_gallery)
		player_galley = closest_gallery
