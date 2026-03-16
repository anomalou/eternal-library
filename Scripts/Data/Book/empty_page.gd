extends PageData
class_name EmptyPage

func _init(_index : int) -> void:
	self.index = _index

func get_data() -> String:
	return ""
