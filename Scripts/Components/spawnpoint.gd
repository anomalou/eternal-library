extends Marker3D
class_name SpawnPoint

var id : String

@export var spawnlist : Dictionary[EnumTypes.EnvironmentType, float]

# for id generation
func get_context() -> String:
	return LibraryUtils.get_context_from_position(self)
