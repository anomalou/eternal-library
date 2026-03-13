extends Resource
class_name Config

var config_id : String :
	get:
		var res_path = resource_path
		return res_path.get_file().get_basename()
