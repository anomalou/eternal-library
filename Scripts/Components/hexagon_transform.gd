extends Node3D
class_name HexagonTransform

var hex_position : HexCoord = HexCoord.new()

var _config : HexagonConfig

var height : float

func _ready() -> void:
	_config = ConfigurationManager.get_by_id("hexagon")
	height = _config.height
