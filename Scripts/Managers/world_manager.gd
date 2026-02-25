extends Node
class_name WorldManager

var _game_session : GameSession
var _seed_manager : SeedManager
var _entity_manager : EntityManager
var _navigation : WorldNavigation

var _galleries : Dictionary[Vector2i, Gallery] # position / id
var _galleries_topology : Dictionary[Vector2i, GalleryTopology]
var _corridors : Dictionary[String, Array]

func _ready() -> void:
	Signals.player_enter_gallery.connect(_process_player_transition)

func _process_player_transition(_prev_gallery : HexCoord, curr_galley : HexCoord):
	generate_in_range(curr_galley, 3) # rendering distance as secont property

func init(game_session : GameSession):
	self._game_session = game_session
	self._seed_manager = self._game_session.seed_manager
	self._entity_manager = self._game_session.entity_manager
	self._navigation = WorldNavigation.new()

func generate_in_range(_start_gallery : HexCoord, _range : int):
	var new_galleries = _pregenerate_galleries(_start_gallery, _range)
	var world_topology = _pregenerate_corridor(new_galleries)
	var gallery_clasters = _generate_navigation_paths(world_topology.get(0).keys(), world_topology.get(1).values())
	_generate_world(world_topology.get(0), world_topology.get(1))
	#_generate_world(new_galleries, {})

func _pregenerate_galleries(_start_pos : HexCoord, _range : int) -> Dictionary[Vector2i, GalleryTopology]:
	var new_galleries : Dictionary[Vector2i, GalleryTopology]
	
	var start_gallery : Vector2i = Vector2i(_start_pos.q, _start_pos.r)
	for pos in _positions_in_range(start_gallery, _range):
		if not _galleries_topology.has(pos):
			new_galleries.merge(_pregenerate_gallery(pos))
	
	return new_galleries

func _positions_in_range(center : Vector2i, radius : int) -> Array[Vector2i]:
	var positions : Array[Vector2i]
	
	for dx in range(-radius, radius + 1):
		var dy_min = max(-radius, -dx - radius)
		var dy_max = min(radius, -dx + radius)
		
		for dy in range(dy_min, dy_max + 1):
			positions.append(center + Vector2i(dx, dy))
	
	return positions

func _pregenerate_gallery(_pos : Vector2i) -> Dictionary[Vector2i, GalleryTopology]:
	var gallery_type_id = _seed_manager.generate_object_id("gallery_type", str(_pos))
	var gallery_type_rnd = _seed_manager.get_temp_rnd(gallery_type_id)
	# use gallery_type_rnd to select room type
	var gallery_type = EnumTypes.GalleryType.GENERAL
	var gallery_data = GalleryDataManager.get_data(gallery_type)
	
	var gallery_context = ContextBuilder.gallery(_pos.x, 0, _pos.y, gallery_type)
	var gallery_id = _seed_manager.generate_object_id("gallery", gallery_context)
	#var gallery = _entity_manager.create_gallery(gallery_id, _pos, [], gallery_type)
	
	var entrancies_id = gallery_id + "_entr"
	var entrancies_rnd = _seed_manager.get_temp_rnd(entrancies_id)
	var entrance_count = entrancies_rnd.randi_range(gallery_data.min_entrances, gallery_data.max_entramces)
	
	var gallery : GalleryTopology = GalleryTopology.new()
	gallery.id = gallery_id
	gallery.type = gallery_type
	gallery.entrance_count = entrance_count
	
	var all_dir = EnumTypes.Direction.values();
	all_dir = _seed_manager.shuffle(all_dir, entrancies_rnd)
	
	var entrance_chanses : Dictionary[EnumTypes.Direction, float] = {}
	for dir_index in range(entrance_count):
		@warning_ignore("integer_division")
		var dir = all_dir.get(dir_index)
		var dir_name = EnumTypes.Direction.find_key(dir)
		var dir_id = gallery_id + dir_name;
		var dir_rnd = _seed_manager.get_temp_rnd(dir_id)
		entrance_chanses.set(dir, dir_rnd.randf())
	
	gallery.entrance_chanse = entrance_chanses
	
	return {_pos : gallery} 

func _pregenerate_corridor(new_galleries : Dictionary[Vector2i, GalleryTopology]) -> Array:
	var connected_galleries : Dictionary[Vector2i, GalleryTopology] = Dictionary(new_galleries)
	var corridors : Dictionary[String, Array] = {}
	for pos : Vector2i in new_galleries.keys():
		var new_gallery : GalleryTopology = new_galleries.get(pos)
		if not new_gallery.entrance_chanse.keys().is_empty():
			var hex_pos : HexCoord = HexCoord.new(pos.x, 0, pos.y)
			var neighs : Array[HexCoord] = HexCoord.new(pos.x, 0, pos.y).neighbours()
			for dir : EnumTypes.Direction in new_gallery.entrance_chanse.keys():
				var neigh_pos = neighs.get(dir)
				var corridor_id = _seed_manager.generate_object_id("corridor", ContextBuilder.corridor(hex_pos, neigh_pos))
				if not _corridors.has(corridor_id) and not corridors.has(corridor_id):
					var neight_pos2 = Vector2i(neigh_pos.q, neigh_pos.r)
					var neigh_dir = (dir + 3) % 6
					var neigh : GalleryTopology
					if new_galleries.has(neight_pos2): # if neighbour is new gallery
						neigh = new_galleries.get(neight_pos2)
					elif _galleries_topology.has(neight_pos2): # if neighbour is old gallery
						neigh = _galleries_topology.get(neight_pos2)
						connected_galleries.set(neight_pos2, neigh)
					else:
						print_debug("Corridor between ", pos, " and ", neight_pos2, " will not been created because ", neight_pos2, " not exists")
					if neigh:
						if neigh.entrance_chanse.has(neigh_dir):
							var corridor_rnd = _seed_manager.get_temp_rnd(corridor_id)
							var chanse = corridor_rnd.randf()
							var avg_chanse = (new_gallery.entrance_chanse.get(dir) + neigh.entrance_chanse.get(neigh_dir))
							if chanse < avg_chanse:
								new_gallery.entrancies.push_back(dir)
								neigh.entrancies.push_back(neigh_dir)
								corridors.set(corridor_id, [pos, neight_pos2])
								print_debug("Corridor ", corridor_id, " between ", hex_pos.to_str(), " and ", neigh_pos.to_str(), " created")
						else:
							print_debug("Neighbour gallery ", neigh_pos.to_str(), " won't connect to ", hex_pos.to_str())
	return [connected_galleries, corridors]

func _generate_navigation_paths(nodes : Array[Vector2i], connections : Array[Array]) -> Array[Array]:
	var node_dict : Dictionary[Vector2i, int] = {}
	for node in nodes:
		var node_id = _navigation.add_node(node)
		node_dict.set(node, node_id)
	
	for connection : Array[Vector2i] in connections:
		_navigation.add_connection(connection.get(0), connection.get(1))
	
	# clasters calculation
	var free_nodes = Array(nodes)
	var clasters : Array[Array] = [] # clasters with connected nodes
	
	while not free_nodes.is_empty():
		var node = free_nodes.pop_front()
		var claster : Array[Vector2i] = [node]
		var remains_nodes = Array(free_nodes)
		for remain_node in remains_nodes:
			if _navigation.has_path(node, remain_node):
				free_nodes.erase(remain_node)
				claster.append(remain_node)
		clasters.append(claster)
		print_debug("Claster generated with ", claster.size(), " rooms. Claster: ", claster)
	
	return clasters

func _generate_world(pregen_galleries : Dictionary[Vector2i, GalleryTopology], pregen_corridors : Dictionary[String, Array]):
	for gallery_pos in pregen_galleries.keys():
		var topology : GalleryTopology = pregen_galleries.get(gallery_pos)
		if _galleries_topology.has(gallery_pos):
			var gallery : Gallery = _galleries.get(gallery_pos)
			gallery.regenerate(topology.entrancies)
		else:
			var gallery : Gallery = _entity_manager.create_gallery(topology.id, gallery_pos, topology.entrancies, topology.type)
			
			_galleries.set(gallery_pos, gallery)
	for corridor_id in pregen_corridors.keys():
		var g1 = pregen_corridors.get(corridor_id).get(0) as Vector2i
		var g2 = pregen_corridors.get(corridor_id).get(1) as Vector2i
		_entity_manager.create_corridor(corridor_id, g1, g2)
	_galleries_topology.merge(pregen_galleries, true)
	_corridors.merge(pregen_corridors)
