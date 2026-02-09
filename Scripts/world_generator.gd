extends Node
class_name WorldGenerator

var _gallery_types : Dictionary[EnumTypes.GalleryType, PackedScene]

func _ready() -> void:
	_gallery_types = {
		EnumTypes.GalleryType.GENERAL : load("res://Prefabs/Gallery.tscn")
	}

func generate_world():
	var gallery_pref = _gallery_types.get(EnumTypes.GalleryType.GENERAL) as PackedScene
	for x in range(10):
		for y in range(10):
			var gallery_key = str(x) + "_0_" + str(y)
			var gallery = gallery_pref.instantiate() as Gallery
			gallery.name = gallery_key
			add_child(gallery)
			gallery.set_deferred("owner", self)
			gallery.apply_position(HexCoord.new(x, 0, y))
			gallery.generate_gallery(SeedManager.generate_object_id("", "gallery", gallery))
			
