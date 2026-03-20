extends Node
class_name PlayerManager

var player_id : String
var player : CharacterBody3D
var player_gallery : HexCoord # current gallery player visiting

var _seed_manager : SeedManager
var _randomizer : RandomNumberGenerator
var _player_pref : PackedScene

func _init() -> void:
	self._player_pref = load("res://Prefabs/Player.tscn")
	Signals.player_enter_gallery.connect(debug_player_room)

func _physics_process(_delta: float) -> void:
	_calculate_player_transition()
	if player:
		Signals.player_move.emit(player.position, Vector2(player.look_x, player.look_y))

func debug_player_room(from : HexCoord, to : HexCoord):
	var distance_from = player.global_position.distance_to(from.global_coord)
	var distance_to = player.global_position.distance_to(to.global_coord)
	Log.info("Player moved from ", from.to_str(), " to ", to.to_str())
	Log.info("Distance from ", distance_from, ", distance to ", distance_to)

func init(seed_manager : SeedManager):
	self._seed_manager = seed_manager

func spawn_player():
	if player:
		push_error("Player allready exists and will not be institated")
		return
	
	player_id = _seed_manager.generate_object_id("player")
	_randomizer = _seed_manager.get_rnd(player_id)
	
	player = _player_pref.instantiate()
	player.name = player_id
	add_child(player)
	player.set_deferred("owner", self)
	# randomize player position by seed generator (but for now it will be ZERO
	player_gallery = HexCoord.new()
	player.position = player_gallery.global_coord
	player.position += Vector3(0, 6, 0)

func _calculate_player_transition():
	if not player:
		return # player not exists so no need to calculate
	
	var player_position = player.global_position
	var room_position = player_gallery.global_coord
	
	var current_distance = player_position.distance_to(room_position)
	if current_distance > (player_gallery.size * sqrt(3) / 2 + player_gallery.spacing * 0.65):
		var min_distance = null
		var closest_gallery : HexCoord = player_gallery
		for neigh in player_gallery.neighbours():
			var dist = player_position.distance_to(neigh.global_coord)
			if min_distance == null or dist < min_distance:
				min_distance = dist
				closest_gallery = neigh
		Signals.player_enter_gallery.emit(player_gallery, closest_gallery)
		player_gallery = closest_gallery
