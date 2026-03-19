extends Shelf
class_name ShelfInteractive

@onready var _interactable : Interactable = $Interactable

var _knowledge_books : Array[int]

func generate(_id : String):
	super(_id)
	_generate_knowledge()
	var mesh_size = Vector3(book_number, 2.5, 1)
	var mesh_offset = Vector3(book_number / 2.0, 1.3, 1)
	_interactable.configure_area(mesh_size, mesh_offset)
	_interactable.connect_action(_interact_action)

func _generate_knowledge():
	for i in range(book_number):
		var book_id = _seed_manager.generate_object_id("book", str(i), id)
		var rnd = _seed_manager.get_temp_rnd(book_id)
		if rnd.randf() > 0.9:
			if rnd.randf() > 0.2:
				_knowledge_books.append(i)
			var inst_transform = multimesh.get_instance_transform(i)
			inst_transform.origin = inst_transform.origin + Vector3(0, 0, rnd.randf_range(0.0, 0.6))
			multimesh.set_instance_transform(i, inst_transform)

func hide_book(_hide : bool, index : int):
	var inst_transform = multimesh.get_instance_transform(index)
	inst_transform = inst_transform.scaled_local(Vector3.ZERO if _hide else Vector3.ONE)
	multimesh.set_instance_transform(index, inst_transform)
	if _hide:
		taken_books.append(index)
	else:
		taken_books.erase(index)

func _interact_action(point : Vector3):
	pass
