@tool
extends EditorPlugin
class_name QuestsPlugin

const QuestsEditorResource = preload("res://addons/QuestsPlugin/quests_editor.gd")
var _editor : QuestsEditor

func _enter_tree() -> void:
	_editor = QuestsEditorResource.new()
	add_control_to_bottom_panel(_editor, "Quests Editor")

func _disable_plugin() -> void:
	remove_control_from_bottom_panel(_editor)
