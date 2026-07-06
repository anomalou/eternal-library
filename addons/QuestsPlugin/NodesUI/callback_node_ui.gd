@tool
extends QuestNode
class_name CallbackNode

var callback_data : CallbackNodeData

func _init(_callback_data : CallbackNodeData = CallbackNodeData.new()) -> void:
	self.callback_data = _callback_data

func _enter_tree() -> void:
	super()
	title = "Callback"

func _on_node_selected() -> void:
	EditorInterface.inspect_object(callback_data)
