extends Node
class_name  EntityManager

var _entity_cache : Dictionary[String, Node3D] = {}

var _hexagon_config : HexagonConfig
var _corridor_prefab : PackedScene

func init():
	self._hexagon_config = ConfigurationManager.get_by_id("hexagon")
	self._corridor_prefab = load("res://Prefabs/Corridor.tscn")
	Log.info("Entity manager initialized")

func create_gallery(_id : String, _pos : Vector2i, _entrances : Array[EnumTypes.Direction] = [], _type : EnumTypes.GalleryType = EnumTypes.GalleryType.GENERAL) -> Gallery:
	if _entity_cache.get(_id):
		destroy_entity(_id)
	
	var config = GalleryConfigManager.get_by_type(_type)
	var gallery_pref = config.prefab
	var gallery = gallery_pref.instantiate() as Gallery
	var hex_pos = HexCoord.new(_pos.x, 0, _pos.y)
	add_child(gallery)
	gallery.set_deferred("owner", self)
	gallery.name = hex_pos.to_str()
	_entity_cache.set(_id, gallery)
	
	gallery.generate(_id, hex_pos, _entrances)
	
	return gallery

func create_corridor(_id : String, g1 : Vector2i, g2 : Vector2i) -> Corridor:
	if _entity_cache.get(_id):
		destroy_entity(_id)
	
	var corridor = _corridor_prefab.instantiate() as Corridor
	var hex_g1 = HexCoord.new(g1.x, 0, g1.y)
	var hex_g2 = HexCoord.new(g2.x, 0, g2.y)
	add_child(corridor)
	corridor.set_deferred("owner", self)
	corridor.name = hex_g1.to_str() + "-" + hex_g2.to_str()
	_entity_cache.set(_id, corridor)
	
	corridor.generate(_id, _hexagon_config.height, hex_g1, hex_g2)
	
	return corridor

func create_entity(_id : String, entity_name : String, parent : Node3D) -> Entity:
	if _entity_cache.get(_id):
		destroy_entity(_id)
	
	var config = EntityConfigManager.get_by_name(entity_name)
	var entity_prefab = config.prefab
	var entity = entity_prefab.instantiate() as Entity
	parent.add_child(entity)
	entity.set_deferred("owner", parent)
	entity.name = entity_name
	_entity_cache.set(_id, entity)
	
	entity.generate(_id)
	
	return entity

func destroy_entity(_id : String):
	if _entity_cache.has(_id):
		var entity : GameObject = _entity_cache.get(_id)
		_entity_cache.erase(_id)
		entity.queue_free()
		var old_cache = Dictionary(_entity_cache)
		for id in old_cache:
			if not old_cache.get(id):
				_entity_cache.erase(id)
		Log.info(_id, " freed")
	else:
		Log.info(_id, " not exists")
