extends Node
class_name WorldGenerator

var _galleries : Dictionary[String, Gallery] = {} # kay is build as galleryX_Y_Z
var _gallery_types : Dictionary[EnumTypes.GalleryType, PackedScene]

func _ready() -> void:
	_gallery_types = {
		EnumTypes.GalleryType.GENERAL : load("res://Prefabs/Gallery.tscn")
	}
	
	generate_world()

func generate_world():
	var gallery_pref = _gallery_types.get(EnumTypes.GalleryType.GENERAL) as PackedScene
	for x in range(6):
		for y in range(6):
			var gallery = gallery_pref.instantiate() as Gallery
			add_child(gallery)
			gallery.owner = get_tree().edited_scene_root
			_galleries.set("gallery" + str(x) + "_0_" + str(y), gallery)
			gallery.apply_position(HexCoord.new(x, 0, y))
			gallery.generate_gallery(0)
			
