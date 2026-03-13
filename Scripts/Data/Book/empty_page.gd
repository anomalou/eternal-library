extends PageData
class_name EmptyPage

func _init() -> void:
	self.type = EnumTypes.PageType.GIBBERISH

func get_data() -> String:
	return ""
