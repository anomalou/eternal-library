extends Control
class_name PageBuilder

@onready var tabs : TabContainer = $VContainer/TabContainer
@onready var note : RichTextLabel = $VContainer/TabContainer/Note/Content
@onready var page_index : Label = $VContainer/PageIndex

func build(page : PageData):
	tabs.current_tab = get_tab(page)
	note.text = page.get_data()
	page_index.text = str(page.index)

func get_tab(page : PageData):
	if page is EmptyPage or page is NotePage:
		return 0
