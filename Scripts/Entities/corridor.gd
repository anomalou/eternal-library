extends Entity
class_name Corridor

var _direction : Vector3 = Vector3.RIGHT
var _width : float
var _length : float

var _floor_generator : BoxFloorGenerator
var _walls_ganerator : BoxWallsGenerator

func _ready() -> void:
	self._floor_generator = $BoxFloorGenerator
	self._walls_ganerator = $BoxWallsGenerator

func _apply_position(g1 : HexCoord, g2 : HexCoord):
	var v1 = g1.global_coord
	var v2 = g2.global_coord
	var center = (v2 - v1) / 2
	var pos = v1 + center
	position = pos
	self._direction = v2 - v1
	self._width = g1.size
	self._length = g1.spacing

func generate(_id : String, g1 : HexCoord, g2 : HexCoord):
	self.id = _id
	_apply_position(g1, g2)
	_floor_generator.generate(self._width, self._length, self._direction)
	_walls_ganerator.generate(self._width, self._length, self._direction)
	print_debug("Corridor ", id, " is ready between ", g1.to_str(), " and ", g2.to_str())
	
