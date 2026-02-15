extends Entity
class_name Corridor

var _floor_generator : BoxFloorGenerator

func _ready() -> void:
	self._floor_generator = $BoxFloorGenerator

func _apply_position(g1 : HexCoord, g2 : HexCoord):
	var v1 = g1.global_coord
	var v2 = g2.global_coord
	var center = (v2 - v1) / 2
	var pos = v1 + center
	position = pos

func generate(_id : String, g1 : HexCoord, g2 : HexCoord):
	self.id = _id
	_apply_position(g1, g2)
	_floor_generator.generate(g1, g2)
	
