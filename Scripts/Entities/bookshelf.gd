extends Entity
class_name Bookshelf

@onready var _spawn_point_manager : SpawnEntityManager = $SpawnPointManager

func generate(_id : String):
	self.id = _id
	var spawnpoints_id = _seed_manager.generate_object_id("spawnpoints", "", id)
	_spawn_point_manager.generate(spawnpoints_id)
	Log.info(id, " bookshelf generated")
