class_name WorldNavigation

var _topology : AStar2D = AStar2D.new()

func add_node(vec : Vector2i) -> int:
	var node_id = ContextBuilder.to_hash2i(vec)
	if not _topology.has_point(node_id):
		_topology.add_point(node_id, vec)
	return node_id

func add_connection(point1 : Vector2i, point2 : Vector2i):
	var p1_id = add_node(point1)
	var p2_id = add_node(point2)
	if not _topology.are_points_connected(p1_id, p2_id):
		_topology.connect_points(p1_id, p2_id)

func has_path(point1 : Vector2i, point2 : Vector2i) -> bool:
	print_debug("Checking connection between ", point1, " and ", point2)
	var p1_id = ContextBuilder.to_hash2i(point1)
	var p2_id = ContextBuilder.to_hash2i(point2)
	return not _topology.get_point_path(p1_id, p2_id).is_empty()
