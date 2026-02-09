class_name  EntityManager

var entity_cache : Dictionary[String, Object] = {}

func get_by_id(id : String) -> Object:
	return entity_cache.get(id)

func set_by_id(id : String, obj : Object):
	entity_cache.set(id, obj)
