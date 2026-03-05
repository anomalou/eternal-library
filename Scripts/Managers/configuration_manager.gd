extends Node
# Load game and engine configurations. Not games objects configs! 
# Example: game setting, constants that require tuning while development, etc. 

const CONFIGURATIONS_PATH = "res://Resources/Configurations/"

var _configuration : Dictionary[String, Resource]

func _ready() -> void:
	

func _load_configurations():
	var configurations = LibraryUtils.load_configuration_resources(CONFIGURATIONS_PATH)
	for 
