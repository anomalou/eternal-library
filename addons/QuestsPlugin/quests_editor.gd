@tool
extends Control
class_name QuestsEditor

var _root : Control
var _graph_edit : GraphEdit

func _ready() -> void:
	_build_editor()

func _build_editor() -> void:
	custom_minimum_size = Vector2i(200, 200)
	
	_root = VBoxContainer.new()
	_root.set_anchors_preset(PRESET_FULL_RECT)
	add_child(_root)
	
	var menu : MenuBar = MenuBar.new()
	menu.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_root.add_child(menu)
	
	var quest_button : PopupMenu = PopupMenu.new()
	quest_button.name = "Quest"
	quest_button.add_item("New")
	quest_button.add_item("Load")
	quest_button.add_item("Save")
	quest_button.id_pressed.connect(_quest_menu)
	menu.add_child(quest_button)
	
	var node_button : PopupMenu = PopupMenu.new()
	node_button.name = "Node"
	node_button.add_item("Callback")
	node_button.add_item("Condition")
	node_button.id_pressed.connect(_create_node)
	menu.add_child(node_button)

func _quest_menu(id : int):
	if id == 0:
		_new_quest()

func _new_quest():
	if _graph_edit:
		var dialog : ConfirmationDialog = ConfirmationDialog.new()
		dialog.title = "Are you sure?"
		dialog.dialog_text = "Close current quest?"
		dialog.ok_button_text = "Yes"
		dialog.cancel_button_text = "Cancel"
		dialog.confirmed.connect(_close_and_create_quest)
		
		EditorInterface.get_base_control().add_child(dialog)
		dialog.popup_centered()
	else:
		_create_quest()

func _close_and_create_quest():
	_clear_quest()
	_create_quest()

func _create_quest():
	_graph_edit = GraphEdit.new()
	_graph_edit.set_anchors_preset(PRESET_FULL_RECT)
	_graph_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_graph_edit.show_grid = true
	_graph_edit.add_valid_left_disconnect_type(1)
	_root.add_child(_graph_edit)
	
	var start : StartNode = StartNode.new()
	start.position_offset = Vector2(-100, 0)
	_graph_edit.add_child(start)
	
	var end : EndNode = EndNode.new()
	end.position_offset = Vector2(100, 0)
	_graph_edit.add_child(end)
	
	_graph_edit.connection_request.connect(_on_connection_request)
	_graph_edit.disconnection_request.connect(_on_disconnection_request)

func _clear_quest():
	_graph_edit.queue_free()
	_graph_edit = null

func _create_node(id : int):
	var node : GraphNode
	if id == 0: # callback
		node = CallbackNode.new()
	elif id == 1: # condition
		node = ConditionNode.new()
	_graph_edit.add_child(node)

func _on_connection_request(from_node : StringName, from_slot : int, to_node : StringName, to_slot : int):
	print("Try to connect")
	var from : BaseNode = _graph_edit.get_node(NodePath(from_node))
	var to : BaseNode = _graph_edit.get_node(NodePath(to_node))
	
	var from_check : bool = from.check_connection_to(to, from_slot)
	var to_check : bool = to.check_connection_from(from, to_slot)
	
	if from_check and to_check:
		from.connect_to_node(to, from_slot)
		to.connect_to_node(from, to_slot)
		_graph_edit.connect_node(from_node, from_slot, to_node, to_slot)
		print("Connected")

func _on_disconnection_request(from_node : StringName, from_slot : int, to_node : StringName, to_slot : int):
	print("Try to disconnect")
	var from : BaseNode = _graph_edit.get_node(NodePath(from_node))
	var to : BaseNode = _graph_edit.get_node(NodePath(to_node))
	
	from.on_disconnection(from_slot)
	to.on_disconnection(to_slot)
	
	_graph_edit.disconnect_node(from_node, from_slot, to_node, to_slot)

func _on_connectin_drag_started(from_node: StringName, from_port: int, is_right: bool):
	pass
	#var from : BaseNode = _graph_edit.get_node(NodePath(from_node))
	#if from.has_connection(from_port, is_right):
		#_graph_edit.disconnect_node()
