class_name GameSession

var seed_manager : SeedManager
var entity_manager : EntityManager

func create(_seed : int = 0):
	seed_manager = SeedManager.new(_seed)
	entity_manager = EntityManager.new()
