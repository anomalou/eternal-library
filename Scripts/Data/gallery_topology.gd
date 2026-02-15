# support world manager class for galleries topology storage
class_name GalleryTopology

var id : String
var type : EnumTypes.GalleryType
var start_entrance : int
var entrance_count : int
var entrance_chanse : Dictionary[EnumTypes.Direction, float]
var entrancies : Array[EnumTypes.Direction]
