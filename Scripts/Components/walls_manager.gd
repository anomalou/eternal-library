@tool
extends Node3D
class_name WallsManager

@export_flags("N", "NW", "SW", "S", "SE", "NE") var entrances : int = 0b010101
@export var max_entrance : int = 3
@export var wall_material : Material
@export var entrance_material : Material

var _trfm : HexCoord
var _height : int

func setup(trfm : HexCoord, height : int):
	self._trfm = trfm
	self._height = height
