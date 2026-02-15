class_name ContextBuilder

const POS_SEP = "_"

static func from_vec3(vec : Vector3) -> String:
	return floor(vec.x) + POS_SEP + floor(vec.y) + POS_SEP + floor(vec.z)

static func gallery(x : int, y : int, z : int, type : EnumTypes.GalleryType) -> String:
	return "{0}_{1}_{2}_{3}".format([x, y, z, EnumTypes.gallery_to_str(type)])

static func gallery_hex(pos : HexCoord, type : EnumTypes.GalleryType) -> String:
	return "{0}_{1}_{2}_{3}".format([pos.q, pos.y, pos.r, EnumTypes.gallery_to_str(type)])

static func corridor(gallery1 : HexCoord, gallery2 : HexCoord) -> String:
	return HexCoord.min(gallery1, gallery2).to_str() + POS_SEP + HexCoord.max(gallery1, gallery2).to_str()
