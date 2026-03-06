extends Node3D
class_name HexagonTransform

var hex_position : HexCoord = HexCoord.new()

var _config : HexagonConfig

@export var pos : Vector3i:
	get:
		return Vector3i(hex_position.q, hex_position.y, hex_position.r)

@export var size : float:
	get:
		return hex_position.size

@export var height : float

func _ready() -> void:
	_config = ConfigurationManager.get_config("hexagon")
	height = _config.height
