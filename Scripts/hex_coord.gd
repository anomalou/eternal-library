class_name HexCoord

# flat side on top

var x : float
var y : float
var z : float
var global_coord : Vector3
var size : float

func _init(_x = 0, _y = 0, _z = 0) -> void:
	self.size = 64
	var short_side = int(size * sqrt(3) / 2)
	var long_side = int(size / 2)
	self.x = _x
	self.y = _y
	self.z = _z
	if (_x % 2 == 0):
		self.global_coord = Vector3(x * long_side * 2 + long_side * 2, y, z * short_side + short_side)
	else:
		self.global_coord = Vector3(x * long_side * 3 + long_side * 2, y, z * short_side + short_side * 2)

func update(coord : HexCoord):
	self._init(coord.x, coord.y, coord.z)

func plus(offset : HexCoord) -> HexCoord:
	return HexCoord.new(x + offset.x, y + offset.y, z + offset.z)

func mul(value : int) -> HexCoord:
	return HexCoord.new(x * value, y * value, z * value)

func to_str():
	return "({x}, {y}, {z})".format({"x":x, "y":y, "z":z})
