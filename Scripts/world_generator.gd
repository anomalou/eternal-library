extends Node
class_name WorldGenerator

var _galleries : Dictionary[String, Gallery] = {} # kay is build as galleryX_Y_Z
var _gallery_types : Dictionary[EnumTypes.GalleryType, PackedScene]

var world_seed : int

func _ready() -> void:
	_gallery_types = {
		EnumTypes.GalleryType.GENERAL : load("res://Prefabs/Gallery.tscn")
	}
	
	world_seed = SeedManager.get_root_seed()
	
	generate_world()

func generate_world():
	var gallery_pref = _gallery_types.get(EnumTypes.GalleryType.GENERAL) as PackedScene
	for x in range(10):
		for y in range(10):
			var gallery_key = str(x) + "_0_" + str(y)
			var gallery = gallery_pref.instantiate() as Gallery
			add_child(gallery)
			gallery.set_deferred("owner", self)
			_galleries.set(gallery_key, gallery)
			gallery.apply_position(HexCoord.new(x, 0, y))
			gallery.generate_gallery(SeedManager.generate_object_id("", "gallery", gallery))
			
