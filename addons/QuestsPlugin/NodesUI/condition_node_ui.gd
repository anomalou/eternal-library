@tool
extends QuestNode
class_name ConditionNode

var _is_true_connected : bool = false
var _is_false_connected : bool = false

func _init(_condition_data : ConditionNodeData = ConditionNodeData.new()) -> void:
	self.data = _condition_data

func _enter_tree() -> void:
	super()
	title = "Predicate"
	var _true : Label = Label.new()
	_true.text = "true"
	add_child(_true)
	var _false : Label = Label.new()
	_false.text = "false"
	add_child(_false)
	
	set_slot(0, true, 0, Color.GRAY, false, 0, Color.GRAY)
	set_slot(1, false, 0, Color.WEB_GREEN, true, 0, Color.WEB_GREEN)
	set_slot(2, false, 0, Color.DARK_RED, true, 0, Color.DARK_RED)

func _on_node_selected() -> void:
	EditorInterface.inspect_object(data)

func check_connection_from(node : BaseNode, slot : int) -> bool:
	return true

func check_connection_to(node : BaseNode, slot : int) -> bool:
	if slot == 0:
		return not _is_true_connected
	elif slot == 1:
		return not _is_false_connected
	else:
		return false

func has_connection(slot : int, is_right : bool):
	if is_right:
		if slot == 0:
			return _is_true_connected
		elif slot == 1:
			return _is_false_connected
		else:
			return false
	return false

func connect_to_node(node : BaseNode, slot : int, is_right : bool):
	if is_right:
		if slot == 0:
			_is_true_connected = true
		elif slot == 1:
			_is_false_connected = true

func on_disconnection(slot : int, is_right : bool):
	if is_right:
		if slot == 0:
			_is_true_connected = false
		elif slot == 1:
			_is_false_connected = false
