@tool
extends QuestNode
class_name CallbackNode

var callback_data : CallbackNodeData

func _init(_callback_data : CallbackNodeData = CallbackNodeData.new()) -> void:
	self.callback_data = _callback_data

func _enter_tree() -> void:
	super()
	title = "Callback"
	var connection_label : Label = Label.new()
	connection_label.text = "connection"
	add_child(connection_label)
	set_slot(0, true, 0, Color.GRAY, true, 0, Color.DARK_GRAY)

func _on_node_selected() -> void:
	EditorInterface.inspect_object(callback_data)
