class_name HexCoord

# flat side on top
# grid coords
# 	x --->
# y
# |
# v
# hex coords
# 	x
# y   \
# |     \
# v      v

var x : float
var y : float
var z : float
var global_coord : Vector3 = Vector3.ZERO
var size : float
#var grid_basis : Transform2D
#var hex_basis : Transform2D

func _init(_x, _y, _z, _size : float) -> void:
	self.size = _size
	var short_side = int(size * sqrt(3) / 2)
	var long_side = int(size / 2)
	#self.grid_basis.x = Vector2(short_side, 0)
	#self.grid_basis.y = Vector2(0, long_side)
	#self.hex_basis.x = grid_basis.y + grid_basis.x * 3
	#self.hex_basis.y = grid_basis.y * 2
	self.x = _x
	self.y = _y
	self.z = _z
	if (_x % 2 == 0):
		self.global_coord = Vector3(x * long_side * 2 + long_side * 2, y, z * short_side + short_side)
	else:
		self.global_coord = Vector3(x * long_side * 3 + long_side * 2, y, z * short_side + short_side * 2)

func plus(offset : HexCoord) -> HexCoord:
	return HexCoord.new(x + offset.x, y + offset.y, z + offset.z, size)

func mul(value : int) -> HexCoord:
	return HexCoord.new(x * value, y * value, z * value, size)
