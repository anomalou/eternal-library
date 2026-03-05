extends Node
# Load configs about all possible galleries in the game.
# For now its only used for galleries, but in future it may be used for all "global" game objects,
# like corridors, etc

const GALLERY_CONFIG_PATH = "res://Resources/Galleries/"

var _gallery_configs : Dictionary[EnumTypes.GalleryType, GalleryConfig]

func _ready() -> void:
	_load_gallery_configurations()
	
func _load_gallery_configurations():
	var gallery_configs = LibraryUtils.load_configuration_resources(GALLERY_CONFIG_PATH)
	for gallery_config in gallery_configs:
		if gallery_config is GalleryConfig:
			_gallery_configs[gallery_config.gallery_type] = gallery_config
			Log.info("Loaded gallery data: ", gallery_config.gallery_type)

func get_config(type : EnumTypes.GalleryType) -> GalleryConfig:
	return _gallery_configs.get(type, _gallery_configs.get(EnumTypes.GalleryType.GENERAL))
