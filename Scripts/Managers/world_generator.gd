extends Node
class_name WorldGenerator

const ENTRANCIES : Array[EnumTypes.Direction] = [EnumTypes.Direction.NE, EnumTypes.Direction.E, EnumTypes.Direction.SW, EnumTypes.Direction.W]

var _config : SessionConfig
var _seed_manager : SeedManager
var _entity_manager : EntityManager
var _navigation : WorldNavigation

var _galleries : Dictionary[Vector2i, Gallery] # position / id
var _galleries_topology : Dictionary[Vector2i, GalleryTopology]
var _corridors : Dictionary[String, Array]

func _ready() -> void:
	Signals.player_enter_gallery.connect(_process_player_transition)

func _process_player_transition(_prev_gallery : HexCoord, curr_galley : HexCoord):
	generate_in_range(curr_galley, 1)
	unload_in_range(curr_galley, 2)

func init(config : SessionConfig, seed_manager : SeedManager, entity_manager : EntityManager):
	self._config = config
	self._seed_manager = seed_manager
	self._entity_manager = entity_manager
	self._navigation = WorldNavigation.new()

func generate_in_range(_start_gallery : HexCoord, _range : int):
	var new_galleries = _pregenerate_galleries(_start_gallery, _range)
	var world_topology = _pregenerate_corridor(new_galleries)
	_generate_navigation_paths(world_topology.get(0).keys(), world_topology.get(1).values())
	call_deferred("_generate_world", world_topology.get(0), world_topology.get(1))

func unload_in_range(_start_gallery : HexCoord, _range : int):
	var start_gallery : Vector2i = Vector2i(_start_gallery.q, _start_gallery.r)
	var galleries_to_stay : Array[Vector2i] = _positions_in_range(start_gallery, _range)
	for pos in _galleries.keys():
		if not galleries_to_stay.has(pos):
			var gallery : Gallery = _galleries.get(pos)
			var gallery_id = gallery.id
			_galleries.erase(pos)
			_galleries_topology.erase(pos)
			for corridor in _corridors.keys():
				if _corridors.get(corridor).has(pos):
					_corridors.erase(corridor)
					_entity_manager.destroy_entity(corridor)
			_entity_manager.destroy_entity(gallery_id)
			await get_tree().process_frame
	

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
	# var gallery_type_id = _seed_manager.generate_object_id("gallery_type", str(_pos))
	# var gallery_type_rnd = _seed_manager.get_temp_rnd(gallery_type_id)
	# use gallery_type_rnd to select room type
	var gallery_type = EnumTypes.GalleryType.GENERAL
	
	var gallery_context = ContextBuilder.gallery(_pos.x, 0, _pos.y, gallery_type)
	var gallery_id = _seed_manager.generate_object_id("gallery", gallery_context)
	#var gallery = _entity_manager.create_gallery(gallery_id, _pos, [], gallery_type)
	
	var gallery : GalleryTopology = GalleryTopology.new()
	gallery.id = gallery_id
	gallery.type = gallery_type
	
	return {_pos : gallery} 

func _pregenerate_corridor(new_galleries : Dictionary[Vector2i, GalleryTopology]) -> Array:
	var connected_galleries : Dictionary[Vector2i, GalleryTopology] = Dictionary(new_galleries)
	var corridors : Dictionary[String, Array] = {}
	for pos : Vector2i in new_galleries.keys():
		var hex_pos : HexCoord = HexCoord.new(pos.x, 0, pos.y)
		var neighs : Array[HexCoord] = hex_pos.neighbours()
		for dir : EnumTypes.Direction in ENTRANCIES:
			var neight_pos = neighs.get(dir)
			var neight_pos2 = Vector2i(neight_pos.q, neight_pos.r)
			var corridor_id = _seed_manager.generate_object_id("corridor", ContextBuilder.corridor(hex_pos, neight_pos))
			if not _corridors.has(corridor_id) and not corridors.has(corridor_id):
				var neight : GalleryTopology = null
				if new_galleries.has(neight_pos2):
					neight = new_galleries.get(neight_pos2)
				elif _galleries_topology.has(neight_pos2):
					neight = _galleries_topology.get(neight_pos2)
				if neight:
					corridors.set(corridor_id, [pos, neight_pos2])
					Log.info("Corridor ", corridor_id, " between ", hex_pos.to_str(), " and ", neight_pos.to_str(), " created")
	return [connected_galleries, corridors]

# old random generation
#func _pregenerate_corridor(new_galleries : Dictionary[Vector2i, GalleryTopology]) -> Array:
	#var connected_galleries : Dictionary[Vector2i, GalleryTopology] = Dictionary(new_galleries)
	#var corridors : Dictionary[String, Array] = {}
	#for pos : Vector2i in new_galleries.keys():
		#var new_gallery : GalleryTopology = new_galleries.get(pos)
		#if not new_gallery.entrance_chanse.keys().is_empty():
			#var hex_pos : HexCoord = HexCoord.new(pos.x, 0, pos.y)
			#var neighs : Array[HexCoord] = HexCoord.new(pos.x, 0, pos.y).neighbours()
			#for dir : EnumTypes.Direction in new_gallery.entrance_chanse.keys():
				#var neigh_pos = neighs.get(dir)
				#var corridor_id = _seed_manager.generate_object_id("corridor", ContextBuilder.corridor(hex_pos, neigh_pos))
				#if not _corridors.has(corridor_id) and not corridors.has(corridor_id):
					#var neight_pos2 = Vector2i(neigh_pos.q, neigh_pos.r)
					#var neigh_dir = (dir + 3) % 6
					#var neigh : GalleryTopology
					#if new_galleries.has(neight_pos2): # if neighbour is new gallery
						#neigh = new_galleries.get(neight_pos2)
					#elif _galleries_topology.has(neight_pos2): # if neighbour is old gallery
						#neigh = _galleries_topology.get(neight_pos2)
						#connected_galleries.set(neight_pos2, neigh)
					#else:
						#Log.info("Corridor between ", pos, " and ", neight_pos2, " will not been created because ", neight_pos2, " not exists")
					#if neigh:
						#if neigh.entrance_chanse.has(neigh_dir):
							#var corridor_rnd = _seed_manager.get_temp_rnd(corridor_id)
							#var chanse = corridor_rnd.randf()
							#var avg_chanse = (new_gallery.entrance_chanse.get(dir) + neigh.entrance_chanse.get(neigh_dir))
							#if chanse < avg_chanse:
								#new_gallery.entrancies.push_back(dir)
								#neigh.entrancies.push_back(neigh_dir)
								#corridors.set(corridor_id, [pos, neight_pos2])
								#Log.info("Corridor ", corridor_id, " between ", hex_pos.to_str(), " and ", neigh_pos.to_str(), " created")
						#else:
							#Log.info("Neighbour gallery ", neigh_pos.to_str(), " won't connect to ", hex_pos.to_str())
	#return [connected_galleries, corridors]

func _generate_navigation_paths(nodes : Array[Vector2i], connections : Array[Array]):
	var node_dict : Dictionary[Vector2i, int] = {}
	for node in nodes:
		var node_id = _navigation.add_node(node)
		node_dict.set(node, node_id)
	
	for connection : Array[Vector2i] in connections:
		_navigation.add_connection(connection.get(0), connection.get(1))

func _generate_world(pregen_galleries : Dictionary[Vector2i, GalleryTopology], pregen_corridors : Dictionary[String, Array]):
	for gallery_pos in pregen_galleries.keys():
		var topology : GalleryTopology = pregen_galleries.get(gallery_pos)
		var gallery : Gallery = _entity_manager.create_gallery(topology.id, gallery_pos, ENTRANCIES, topology.type)
		_galleries.set(gallery_pos, gallery)
		await get_tree().process_frame
	
	for corridor_id in pregen_corridors.keys():
		var g1 = pregen_corridors.get(corridor_id).get(0) as Vector2i
		var g2 = pregen_corridors.get(corridor_id).get(1) as Vector2i
		_entity_manager.create_corridor(corridor_id, g1, g2)
		await get_tree().process_frame
	
	_galleries_topology.merge(pregen_galleries, true)
	_corridors.merge(pregen_corridors)
