extends Node
# Load all entities and its configs requeired for institating on scene
# Used by entity manager primary, 
# because configs that contains EntityConfig useing primary while entity creation
# Also can be used by other entities for its children institation

const ENTITY_CONFIG_PATH = "res://Resources/Entities/"

var _entity_configs : Dictionary[String, EntityConfig]

func _ready() -> void:
	_load_entity_configurations()

func _load_entity_configurations():
	var entity_configs = LibraryUtils.load_configuration_resources(ENTITY_CONFIG_PATH)
	for entity_config in entity_configs:
		if entity_config is EntityConfig:
			_entity_configs.set(entity_config.entity_name, entity_config)
			Log.info("Loaded entity configuration: ", entity_config.entity_name)

func get_by_name(entity_name : String):
	return _entity_configs.get(entity_name)

func get_by_type(type : EnumTypes.EntityType) -> Array[EntityConfig]:
	return _entity_configs.values().filter(func (config : EntityConfig): config.type == type)
