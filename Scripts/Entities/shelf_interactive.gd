extends Shelf
class_name ShelfInteractive

@onready var _interactable : Interactable = $Interactable

var _knowledge_books : Array[int]
var _taken_books : Dictionary[String, int]
var _selection_index : int = -1 # -1 mean it have no selection right now
var _selection_color : Color = Color(0.755, 0.563, 0.0, 1.0)
var _selected_book_base_color : Color

func generate(_id : String):
	super(_id)
	_generate_knowledge()
	var mesh_size = Vector3(book_number, 2.5, 1)
	var mesh_offset = Vector3(book_number / 2.0, 1.3, 1)
	_interactable.configure_area(mesh_size, mesh_offset)
	_interactable.connect_actions(_interact_action, _hover_action, _end_hover_action)
	Signals.return_book.connect(_return_book)

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

func _hide_book(_hide : bool, index : int):
	var inst_transform = multimesh.get_instance_transform(index)
	inst_transform = inst_transform.scaled_local(Vector3.ZERO if _hide else Vector3.ONE)
	multimesh.set_instance_transform(index, inst_transform)

func _take_book(book_id : String, index : int) -> void:
	_taken_books.set(book_id, index)
	_hide_book(true, index)
	Log.info("Book ", book_id, " taken from bookshelf ", id)

func _return_book(book_id : String) -> void:
	if _taken_books.has(book_id):
		var index = _taken_books.get(book_id)
		_taken_books.erase(book_id)
		_hide_book(false, index)
		Log.info("Book ", book_id, " returned to bookshelf ", id)

func _process(_delta: float) -> void:
	_process_selection(_selection_index)

func _interact_action(_point : Vector3):
	var book_id = _seed_manager.generate_object_id("book", str(_selection_index), id)
	var pos : Vector3 = multimesh.get_instance_transform(_selection_index).origin
	Signals.prepare_book.emit(book_id, _selected_book_base_color, to_global(pos))
	_take_book(book_id, _selection_index)
	Signals.start_reading.emit(book_id, not _knowledge_books.has(_selection_index))
	Log.info("Used ", _selection_index, " book on bookshell ", id)

func _hover_action(point : Vector3):
	var index = _get_book_index(point)
	if index >= 0 and index < book_number:
		if index != _selection_index:
			var prev_index = _selection_index
			var prev_color = _selected_book_base_color
			_selected_book_base_color = multimesh.get_instance_color(index)
			_selection_index = index
			await get_tree().process_frame
			if prev_index != -1 and prev_index != index:
				_deselect_book(prev_index, prev_color)

func _end_hover_action():
	if _selection_index != -1:
		_deselect_book(_selection_index, _selected_book_base_color)
	_selection_index = -1

func _get_book_index(point : Vector3) -> int:
	point = to_local(point)
	var index = floor(point.x)
	return index

func _process_selection(index : int):
	if index != -1:
		_select_book(index)

func _select_book(index : int):
	var highlight = _selected_book_base_color * Color(1.0, 1.0, 1.0) + _selection_color
	multimesh.set_instance_color(index, highlight)

func _deselect_book(index : int, base_color : Color):
	multimesh.set_instance_color(index, base_color)
