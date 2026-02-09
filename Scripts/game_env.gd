extends Node
var _current_session : WeakRef

func set_current_session(session : GameSession):
	_current_session = weakref(session)
	print_debug("New game session is set up as global env property")

func get_current_session():
	var session = _current_session.get_ref()
	if session:
		return session
	else:
		push_error("Session not valid and not exists. Exceptions will be occured")

func is_session_exist() -> bool:
	return _current_session.get_ref() != null
