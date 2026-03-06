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

static func load_configuration_resources(dir_path : String) -> Array[Config]:
	if not dir_path.ends_with("/"):
		dir_path = dir_path + "/"
	
	var resources : Array[Config] = []
	
	var dir = DirAccess.open(dir_path)
	if not dir:
		Log.error("Cannot open configuration resource directory")
		return []
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var full_path = dir_path + file_name
			var resource = ResourceLoader.load(full_path)
			if resource and resource is Config:
				Log.info("Loaded resource ", full_path)
				resources.append(resource)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return resources
