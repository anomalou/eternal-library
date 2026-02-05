class_name HexCoord

# flat side on top

var q : int
var r : int
var s : int
var y : int
var global_coord : Vector3
var size : float
var spacing : float

var _hex_width : float
var _hex_height : float
var _q_basis : Vector3
var _r_basis : Vector3
var _q_normal : Vector3
var _r_normal : Vector3

func _init(_x = 0, _y = 0, _z = 0) -> void:
	self.size = 64
	self.spacing = 64
	self.q = _x
	self.y = _y
	self.r = _z
	self.s = -self.q - self.r
	
	_calculate_vectors()
	_calculate_global()

func _calculate_vectors():
	self._hex_width = size * 2.0
	self._hex_height = size * sqrt(3.0)
	self._q_basis = Vector3(self._hex_width * 0.75, 0, self._hex_height * 0.5)
	self._r_basis = Vector3(0, 0, self._hex_height)
	self._q_normal = Vector3(self._hex_width * 0.75, 0, self._hex_height * 0.5).normalized()
	self._r_normal = Vector3(0, 0, self._hex_height).normalized()

func _calculate_global():
	var world_x = self._q_basis.x * float(q) + self._r_basis.x * float(r)
	var world_z = self._q_basis.z * float(q) + self._r_basis.z * float(r)
	
	if spacing > 0:
		world_x += spacing * (self._q_normal.x * q + self._r_normal.x * r)
		world_z += spacing * (self._q_normal.z * q + self._r_normal.z * r)
	
	self.global_coord = Vector3(world_x, y, world_z)

func update(coord : HexCoord):
	self._init(coord.x, coord.y, coord.z)

func plus(offset : HexCoord) -> HexCoord:
	return HexCoord.new(q + offset.x, y + offset.y, r + offset.z)

func mul(value : int) -> HexCoord:
	return HexCoord.new(q * value, y * value, r * value)

func to_str():
	return "({x}, {y}, {z})".format({"x":q, "y":y, "z":r})
