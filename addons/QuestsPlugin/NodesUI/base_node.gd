@tool
extends GraphNode
class_name BaseNode

func _enter_tree() -> void:
	pass

func check_connection_from(node : BaseNode, slot : int) -> bool:
	return false

func check_connection_to(node : BaseNode, slot : int) -> bool:
	return false

func on_disconnection(slot : int):
	pass

func connect_to_node(node : BaseNode, slot : int):
	pass

func has_connection(slot : int, is_right : bool):
	pass
