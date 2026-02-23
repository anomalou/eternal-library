class_name Constants

const _const_map : Dictionary[String, String] = {
	"hexagon_config" : "res://Configurations/hexagon_config.tres"
}

static func get_value(key):
	return _const_map.get(key)
