extends Node
class_name StateManager

var states : Dictionary[String, State] # entity_id, entity_state

func init():
	Log.info("State manager initialized")

func save(id : String, state : State):
	states.set(id, state)

func restore(id : String) -> State:
	return states.get(id)

func has_state(id : String) -> bool:
	return states.has(id)
