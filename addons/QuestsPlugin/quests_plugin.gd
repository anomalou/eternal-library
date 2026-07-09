@tool
extends EditorPlugin
class_name QuestsPlugin

const QuestsEditorResource = preload("res://addons/QuestsPlugin/quests_editor.gd")
var _editor : QuestsEditor

func _enter_tree() -> void:
	_editor = QuestsEditorResource.new()
	get_editor_interface().get_editor_main_screen().add_child(_editor)
	_editor.visible = false

func _disable_plugin() -> void:
	remove_control_from_bottom_panel(_editor)

func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return "Quests"

func _make_visible(visible: bool) -> void:
	_editor.visible = visible
