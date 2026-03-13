extends Control
class_name PageBuilder

@onready var tabs : TabContainer = $VContainer/TabContainer
@onready var note : RichTextLabel = $VContainer/TabContainer/Note/Content

func build(type : EnumTypes.PageType):
	tabs.current_tab = get_tab(type)

func get_tab(type : EnumTypes.PageType):
	var mapper = {
		EnumTypes.PageType.GIBBERISH : 0,
		EnumTypes.PageType.KNOWLEDGE : 0,
		EnumTypes.PageType.NOTES : 0
	}
	
	return mapper.get(type, 0)
	
