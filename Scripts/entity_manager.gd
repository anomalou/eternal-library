extends Node
class_name  EntityManager

var entity_cache : Dictionary[String, Node3D] = {}

var _gallery_types : Dictionary[EnumTypes.GalleryType, PackedScene]

func init():
	self._gallery_types = {
		EnumTypes.GalleryType.GENERAL : load("res://Prefabs/Gallery.tscn")
	}
	print_debug("Entity manager initialized")
	pass

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
	
	gallery.generate_gallery(_id, hex_pos, _entrances)
	
	return gallery
