extends Node
class_name  EntityManager

var entity_cache : Dictionary[String, Node3D] = {}

var _gallery_types : Dictionary[EnumTypes.GalleryType, PackedScene]
var _corridor_prefab : PackedScene

func init():
	self._gallery_types = {
		EnumTypes.GalleryType.GENERAL : load("res://Prefabs/Gallery.tscn")
	}
	self._corridor_prefab = load("res://Prefabs/Corridor.tscn")
	print_debug("Entity manager initialized")

func get_by_id(id : String) -> Node3D:
	return entity_cache.get(id)

func set_by_id(id : String, obj : Node3D):
	entity_cache.set(id, obj)

func create_gallery(_id : String, _pos : Vector2i, _entrances : Array[EnumTypes.Direction] = [], _type : EnumTypes.GalleryType = EnumTypes.GalleryType.GENERAL) -> Gallery:
	var gallery_pref = _gallery_types.get(_type) as PackedScene
	var gallery = gallery_pref.instantiate() as Gallery
	var hex_pos = HexCoord.new(_pos.x, 0, _pos.y)
	add_child(gallery)
	gallery.set_deferred("owner", self)
	gallery.name = hex_pos.to_str()
	entity_cache.set(_id, gallery)
	
	gallery.generate(_id, hex_pos, _entrances)
	
	return gallery

func create_corridor(_id : String, g1 : Vector2i, g2 : Vector2i) -> Corridor:
	var corridor = _corridor_prefab.instantiate() as Corridor
	var hex_g1 = HexCoord.new(g1.x, 0, g1.y)
	var hex_g2 = HexCoord.new(g2.x, 0, g2.y)
	add_child(corridor)
	corridor.set_deferred("owner", self)
	corridor.name = hex_g1.to_str() + "-" + hex_g2.to_str()
	entity_cache.set(_id, corridor)
	
	corridor.generate(_id, hex_g1, hex_g2)
	
	return corridor
