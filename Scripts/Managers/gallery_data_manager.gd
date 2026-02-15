extends Node

const GALLERY_DATA_PATH = "res://Resources/Galleries/"

var _gallery_data : Dictionary[EnumTypes.GalleryType, GalleryData]

func _ready() -> void:
	_load_gallery_configurations()
	
func _load_gallery_configurations():
	var dir = DirAccess.open(GALLERY_DATA_PATH)
	if not dir:
		push_error("Cannot open gallery configuration directory")
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var full_path = GALLERY_DATA_PATH + file_name
			var gallery_data = ResourceLoader.load(full_path)
			if gallery_data and gallery_data is GalleryData:
				gallery_data = gallery_data as GalleryData
				_gallery_data[gallery_data.gallery_type] = gallery_data
				print_debug("Loaded gallery data: ", gallery_data.gallery_type)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()

func get_data(type : EnumTypes.GalleryType) -> GalleryData:
	return _gallery_data.get(type, _gallery_data.get(EnumTypes.GalleryType.GENERAL))
