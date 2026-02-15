extends Resource
class_name GalleryData

@export var gallery_type : EnumTypes.GalleryType
@export_range(1, 6) var min_entrances : int = 1
@export_range(1, 6) var max_entramces : int = 3
