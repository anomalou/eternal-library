extends Node
class_name BookController

var _entity_manager : EntityManager
var _state_manager : StateManager
var _book_manager : BookManager

# Controlling right now book's properties
var _book_id : String
var _book_entity : Book
var _book_data : BookData
var _book_state : BookState
var _shelf_place_transform : Transform3D

var camera : Camera3D

var _reset_start_reading = false

func _ready() -> void:
	Signals.prepare_book.connect(_prepare_book)
	Signals.start_reading.connect(_start_reading)

# Also need state manager here 
func init(entity_manager : EntityManager, state_manager : StateManager, book_manager : BookManager):
	self._entity_manager = entity_manager
	self._state_manager = state_manager
	self._book_manager = book_manager
	Log.info("Book controller initialized")

func _input(event: InputEvent) -> void:
	if GameEnv.get_current_session().input_block.get("book", false):
		if event.is_action_pressed("close_book"):
			_stop_reading()
		if event.is_action_pressed("next_page"):
			_turn_page(true)
		if event.is_action_pressed("prev_page"):
			_turn_page(false)

func _prepare_book(book_id : String, color : Color, transform : Transform3D):
	var book : Book = _entity_manager.create_entity(book_id, "book")
	book.set_color(color)
	book.global_transform = transform
	_shelf_place_transform = transform

func _start_reading(book_id : String, is_gibberish : bool):
	Log.info("Book ", _book_id, " start reading")
	GameEnv.get_current_session().input_block.set("book", true)
	var book : Book = await _wait_for_book(book_id)
	if not book:
		GameEnv.get_current_session().input_block.set("book", false)
		return
	_reset_start_reading = false
	_init_book_state(book_id, book, is_gibberish)
	_render_pages([0, 1])
	if not _reset_start_reading:
		await _book_entity.eject_from_shelf()
	if not _reset_start_reading:
		await _book_entity.fly_to_camera(camera.global_transform)
	if not _reset_start_reading:
		await _book_entity.open()
	Log.info("Book ", _book_id, " opened")

func _wait_for_book(book_id : String) -> Book:
	var timeout = 10.0
	var elapsed = 0
	
	var entity = _entity_manager.find(book_id)
	while not entity and elapsed < timeout:
		var entity_id = await _entity_manager.entity_registered
		if entity_id == book_id:
			entity = _entity_manager.find(book_id)
		elapsed += get_process_delta_time()
	
	if not entity or not entity is Book:
		Log.error("Something wrong with book = ", book_id)
	
	return entity

func _init_book_state(book_id : String, entity : Book, is_gibberish : bool) -> void:
	var data = _book_manager.find(book_id)
	
	if not data:
		data = _book_manager.generate_book(book_id, is_gibberish)
	
	var state
	if _state_manager.has_state(book_id):
		state = _state_manager.restore(book_id)
	
	if not state or not state is BookState:
		state = BookState.new()
		state.current_page = 0
		_state_manager.save(book_id, state)
	
	self._book_id = book_id
	self._book_entity = entity
	self._book_data = data
	self._book_state = state

func _stop_reading():
	Log.info("Book ", _book_id, " stop reading")
	_reset_start_reading = true
	_state_manager.save(_book_id, _book_state)
	await _book_entity.close()
	GameEnv.get_current_session().input_block.set("book", false)
	await _book_entity.fly_to_origin(_shelf_place_transform)
	# play return animation here
	# await animation end
	Signals.return_book.emit(_book_id)
	_entity_manager.destroy_entity(_book_id)
	Log.info("Book ", _book_id, " closed")
	_book_id = ""
	_book_entity = null
	_book_data = null
	_book_state = null
	_shelf_place_transform = Transform3D.IDENTITY

func _turn_page(forward : bool = true):
	if _book_id:
		var book_size : int = _book_data.cached_book_size
		var current_index : int = _book_state.current_page
		if forward:
			if (current_index + 2) < book_size:
				_book_state.current_page = current_index + 2
				_render_pages([-2, 1, -1, 0])
				# render order: current page index 2
				# Rendered pages (from left to right) index: 0, 1, 2, 3 (in middle pages on animated page)
				_book_entity.set_page_visible(true)
				await _book_entity.turn_page(forward)
				_render_pages([0, 1])
				_book_entity.set_page_visible(false)
		else:
			if (current_index - 2) >= 0:
				_book_state.current_page = current_index - 2
				_render_pages([0, 3, 1, 2])
				_book_entity.set_page_visible(true)
				await _book_entity.turn_page(forward)
				_render_pages([0, 1])
				_book_entity.set_page_visible(false)

# only usable when book is open. Book state will be in state manager
# also state manager handle current opened page
# order structure:
# [ 0 , 1 , 2 , 3 ]
#  \__^__/ \__^__/
#   Block   Thick
#   pages   page
# 
# Order stores page index offset for properly rendering of each pade side
func _render_pages(order : Array[int]):
	if not _book_id:
		return
	var pages : Array[PageData] = _book_data.split()
	var current_page = _book_state.current_page
	var pages_for_render : Array[PageData] = []
	for offset in order:
		pages_for_render.append(pages.get(current_page + offset))
	_book_entity.render_pages(pages_for_render)
