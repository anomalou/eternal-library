@tool
extends BaseNode
class_name QuestNode

var data : NodeData

func _enter_tree() -> void:
	var close : Button = Button.new()
	close.icon = get_theme_icon("Close", "EditorIcons")
	close.pressed.connect(_close)
	get_titlebar_hbox().add_child(close)
	
	var id_label : LineEdit = LineEdit.new()
	id_label.placeholder_text = "id"
	id_label.text_changed.connect(_update_id)
	
	add_child(id_label)
	
	node_selected.connect(_on_node_selected)

func _update_id(text : String):
	data.id = text

func _close() -> void:
	EditorInterface.inspect_object(null)
	queue_free()

func _on_node_selected() -> void:
	pass

func _execute_node() -> void:
	pass
