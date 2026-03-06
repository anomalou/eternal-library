extends Node

const SPAWN_TABLES_PATH = "res://Resources/SpawnTables/"

var _spawn_tables : Dictionary[String, SpawnTable]

func _ready() -> void:
	_load_spawn_tables()

func _load_spawn_tables():
	var tables = LibraryUtils.load_configuration_resources(SPAWN_TABLES_PATH)
	for table in tables:
		if table is SpawnTable:
			_spawn_tables.set(table.config_id, table)
			Log.info("Loaded spawn table: ", table.config_id)

func get_by_id(id : String) -> SpawnTable:
	return _spawn_tables.get(id)
