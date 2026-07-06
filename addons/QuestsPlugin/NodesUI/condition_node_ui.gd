@tool
extends QuestNode
class_name ConditionNode

@export var condition_data : ConditionNodeData

func _init(_condition_data : ConditionNodeData = ConditionNodeData.new()) -> void:
	self.condition_data = _condition_data

func _enter_tree() -> void:
	super()
	title = "Predicate"

func _on_node_selected() -> void:
	EditorInterface.inspect_object(condition_data)
