@tool
extends BaseNode
class_name EndNode

var _is_connected : bool = false

func _enter_tree() -> void:
	title = "End"
	var in_label : Label = Label.new()
	in_label.text = "input"
	add_child(in_label)
	set_slot_enabled_left(0, true)
	set_slot_color_left(0, Color.GRAY)
	set_slot_type_left(0, 0)

func check_connection_from(node : BaseNode, slot : int) -> bool:
	return true

func connect_to_node(node : BaseNode, slot : int):
	_is_connected = true

func on_disconnection(slot : int):
	_is_connected = false

func has_connection(slot : int, is_right : bool):
	return _is_connected
