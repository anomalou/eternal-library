extends Node
class_name WorldManager

var _game_session : GameSession
var _seed_manager : SeedManager
var _entity_manager : EntityManager

var _galleries : Dictionary[Vector2i, Gallery] # position / id

func _ready() -> void:
	Signals.player_enter_gallery.connect(_process_player_transition)

func _process_player_transition(_prev_gallery : HexCoord, curr_galley : HexCoord):
	generate_in_range(curr_galley, 1) # rendering distance as secont property

func init(game_session : GameSession):
	self._game_session = game_session
	self._seed_manager = self._game_session.seed_manager
	self._entity_manager = self._game_session.entity_manager

func generate_in_range(_start_gallery : HexCoord, _range : int):
	var new_galleries = _generate_galleries(_start_gallery, _range)
	_galleries.merge(new_galleries)

func _generate_galleries(_start_pos : HexCoord, _range : int) -> Dictionary[Vector2i, Gallery]:
	var generate_galleries : Dictionary[Vector2i, Gallery]
	
	var start_gallery : Vector2i = Vector2i(_start_pos.q, _start_pos.r)
	if not _galleries.has(start_gallery): # probably execute only on first generation so chanse always 100%
		var gallery = _generate_gallery(start_gallery)
		generate_galleries.merge(gallery)
	
	for pos in _positions_in_range(start_gallery, _range):
		if not _galleries.has(pos):
			var gallery = _generate_gallery(pos)
			generate_galleries.merge(gallery)
	
	return generate_galleries

func _positions_in_range(center : Vector2i, radius : int) -> Array[Vector2i]:
	var positions : Array[Vector2i]
	
	for dx in range(-radius, radius + 1):
		var dy_min = max(-radius, -dx - radius)
		var dy_max = min(radius, -dx + radius)
		
		for dy in range(dy_min, dy_max + 1):
			positions.append(center + Vector2i(dx, dy))
	
	return positions

func _generate_gallery(_pos : Vector2i) -> Dictionary[Vector2i, Gallery]:
	var gallery_type_id = _seed_manager.generate_object_id("gallery_type", str(_pos))
	var gallery_type_rnd = _seed_manager.get_temp_rnd(gallery_type_id)
	# use gallery_type_rnd to select room type
	var gallery_type = EnumTypes.GalleryType.GENERAL
	
	var gallery_context = ContextBuilder.gallery(_pos.x, 0, _pos.y, gallery_type)
	var gallery_id = _seed_manager.generate_object_id("gallery", gallery_context)
	var gallery = _entity_manager.create_gallery(gallery_id, _pos, [], gallery_type)
	
	return {_pos : gallery} 
