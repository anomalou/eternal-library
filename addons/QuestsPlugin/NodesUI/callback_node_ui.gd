@tool
extends QuestNode
class_name CallbackNode

var _is_connected : bool

func _init(_callback_data : CallbackNodeData = CallbackNodeData.new()) -> void:
	self.data = _callback_data

func _enter_tree() -> void:
	super()
	title = "Callback"
	set_slot(0, true, 0, Color.GRAY, true, 0, Color.DARK_GRAY)

func _on_node_selected() -> void:
	EditorInterface.inspect_object(data)

func check_connection_from(node : BaseNode, slot : int) -> bool:
	return true

func check_connection_to(node : BaseNode, slot : int) -> bool:
	return not _is_connected

func connect_to_node(node : BaseNode, slot : int, is_right : bool):
	if is_right:
		_is_connected = true

func on_disconnection(slot : int, is_right : bool):
	if is_right:
		_is_connected = false
