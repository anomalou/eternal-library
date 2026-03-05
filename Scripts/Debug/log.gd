class_name Log

static func info(...message):
	_debug("INFO", message)

static func error(...message):
	_debug("ERROR", message)

static func _debug(level : String, message : Array):
	var script_name : String
	var stack = get_stack()
	if stack.size() > 2:
		var prev_call : Dictionary = stack.get(2)
		script_name = prev_call.get("source")
		script_name = script_name.rsplit(".", true, 1).get(0)
		script_name = script_name.rsplit("/", true, 1).get(1)
	else:
		push_error("Incorrect logger usage")
	
	var timestamp = Time.get_datetime_string_from_system(false, true);
	var result = "[{0}][{1}][{2}] - {3}".format([timestamp, level, script_name, "".join(message)])
	if level == "ERROR":
		push_error(result)
	elif level == "WARN":
		push_warning(result)
	elif level == "DEBUG":
		print_debug(result)
	else:
		print(result)
	
	
	
