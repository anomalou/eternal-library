extends Node
class_name WorldGenerator

@onready var _seed_manager : SeedManager = $"../SeedManager"

var _galleries : Dictionary[String, Gallery] = {} # kay is build as galleryX_Y_Z
var _gallery_types : Dictionary[EnumTypes.GalleryType, PackedScene]

var _seed : int

func _ready() -> void:
	_gallery_types = {
		EnumTypes.GalleryType.GENERAL : load("res://Prefabs/Gallery.tscn")
	}
	
	_seed = self._seed_manager.get_system_seed(EnumTypes.SystemType.GALLERY_LAYOUT)
	
	generate_world()

func generate_world():
	var gallery_pref = _gallery_types.get(EnumTypes.GalleryType.GENERAL) as PackedScene
	for x in range(6):
		for y in range(6):
			var gallery_key = str(x) + "_0_" + str(y)
			var gallery = gallery_pref.instantiate() as Gallery
			add_child(gallery)
			gallery.set_deferred("owner", self)
			_galleries.set(gallery_key, gallery)
			gallery.apply_position(HexCoord.new(x, 0, y))
			gallery.generate_gallery(self._seed_manager.get_entity_seed(EnumTypes.SystemType.GALLERY, gallery_key))
			
