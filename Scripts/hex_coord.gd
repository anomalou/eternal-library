class_name HexCoord

# flat side on top

var q : int
var r : int
var s : int
var y : int
var global_coord : Vector3
var size : float
var spacing : float

func _init(_x = 0, _y = 0, _z = 0) -> void:
	self.size = 64
	self.spacing = 64
	self.q = _x
	self.y = _y
	self.r = _z
	self.s = -self.q - self.r
	_calculate_global()
	

func _calculate_global():
	var hex_width = size * 2.0
	var hex_height = size * sqrt(3.0)
	
	var world_x = hex_width * float(q) * 0.75
	var world_z = hex_height * (float(r) + float(q) / 2)
	
	self.global_coord = Vector3(world_x, y, world_z)
	
	#var short_side = int(size * sqrt(3) / 2)
	#var long_side = int(size / 2)
	#if (self.x % 2 == 0):
		#self.global_coord = Vector3(
			#x * long_side * 3 + long_side * 2 + clamp(x, -1, 1) * spacing, 
			#y, 
			#z * short_side * 2 + short_side + clamp(z, -1, 1) * spacing)
	#else:
		#self.global_coord = Vector3(
			#x * long_side * 3 + long_side * 2 + clamp(x, -1, 1) * spacing, 
			#y, 
			#z * short_side * 2 + short_side * 2 + clamp(z, -1, 1) * spacing)

func update(coord : HexCoord):
	self._init(coord.x, coord.y, coord.z)

func plus(offset : HexCoord) -> HexCoord:
	return HexCoord.new(q + offset.x, y + offset.y, r + offset.z)

func mul(value : int) -> HexCoord:
	return HexCoord.new(q * value, y * value, r * value)

func to_str():
	return "({x}, {y}, {z})".format({"x":q, "y":y, "z":r})
