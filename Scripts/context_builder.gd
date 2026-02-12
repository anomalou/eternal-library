class_name ContextBuilder

const POS_SEP = "_"

static func from_vec3(vec : Vector3) -> String:
	return floor(vec.x) + POS_SEP + floor(vec.y) + POS_SEP + floor(vec.z)

static func gallery(x : int, y : int, z : int, type : String = "") -> String:
	return "{0}_{1}_{2}_{3}".format([x, y, z, type])

static func gallery_hex(pos : HexCoord, type : String = "") -> String:
	return "{0}_{1}_{2}_{3}".format([pos.q, pos.y, pos.r, type])
