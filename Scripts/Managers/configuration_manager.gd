extends Node
# Load game and engine configurations. Not games objects configs! 
# Example: game setting, constants that require tuning while development, etc. 

const CONFIGURATIONS_PATH = "res://Resources/Configurations/"

var _configuration : Dictionary[String, Config]

func _ready() -> void:
	_load_configurations()

func _load_configurations():
	var configurations = LibraryUtils.load_configuration_resources(CONFIGURATIONS_PATH)
	for configuration in configurations:
		_configuration.set(configuration.config_id, configuration)
		Log.info("Loaded configuration: ", configuration.config_id)

func get_by_id(id : String) -> Config:
	return _configuration.get(id)
