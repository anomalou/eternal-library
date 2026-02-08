class_name LibraryUtils

const POS_SEP = "_"
const ID_ERROR = "ID_ERROR"

static func get_context_from_position(object : Node3D) -> String:
	return floor(object.position.x) + POS_SEP + floor(object.position.y) + POS_SEP + floor(object.position.z)

static func get_parent_id(id : String) -> String:
	if id.ends_with("/"):
		push_error("Provided incorrect id = ", id)
		return ID_ERROR
	var parts = id.split("/") as Array
	if parts.size() > 1:
		parts.pop_back()
		return "/".join(parts)
	else:
		# id is root element and no have parent
		return ""

static func get_object_name(id : String) -> String:
	if id.ends_with("/"):
		push_error("Provided incorrect id = ", id)
		return ID_ERROR
	var parts = id.split("/") as Array
	if parts > 1:
		return parts.pop_back()
	else:
		return id
