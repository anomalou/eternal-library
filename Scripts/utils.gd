class_name LibraryUtils

const ID_ERROR = "ID_ERROR"

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
