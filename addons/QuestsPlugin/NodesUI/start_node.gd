@tool
extends BaseNode
class_name StartNode

var _is_connected : bool = false

func _enter_tree() -> void:
	title = "Start"
	var out_label : Label = Label.new()
	out_label.text = "output"
	add_child(out_label)
	set_slot_enabled_right(0, true)
	set_slot_color_right(0, Color.GRAY)
	set_slot_type_right(0, 0)

func check_connection_to(node : BaseNode, slot : int) -> bool:
	return not _is_connected

func on_disconnection(slot : int):
	_is_connected = false

func connect_to_node(node : BaseNode, slot : int):
	_is_connected = true
