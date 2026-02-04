@tool
extends Node
class_name HexagonTransform

var hex_position : HexCoord = HexCoord.new()


@export var pos : Vector3i:
	get:
		return Vector3i(hex_position.q, hex_position.y, hex_position.r)

@export var size : float:
	get:
		return hex_position.size

@export var height : int = 32
