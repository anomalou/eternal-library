@tool
extends BaseNode
class_name QuestNode

func _enter_tree() -> void:
	var close : Button = Button.new()
	close.icon = get_theme_icon("Close", "EditorIcons")
	close.pressed.connect(_close)
	get_titlebar_hbox().add_child(close)
	
	node_selected.connect(_on_node_selected)

func _close() -> void:
	EditorInterface.inspect_object(null)
	queue_free()

func _on_node_selected() -> void:
	pass

func _execute_node() -> void:
	pass
	
