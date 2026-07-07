extends Node
class_name BookController

var _entity_manager : EntityManager
var _state_manager : StateManager
var _book_manager : BookManager

# Controlling right now book's properties
var _controlled_book : ReadingSession

var camera : Camera3D

func _ready() -> void:
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

func _start_reading(book_id : String, book_properties : BookEntityProperties):
	Log.info("Book ", _controlled_book.book_id, " start reading")
	var book : Book = _entity_manager.create_entity(book_id, "book")
	book.set_color(book_properties.color)
	book.global_transform = book_properties.bookshelf_origin_transform
	_controlled_book.shelf_place_transform = book_properties.bookshelf_origin_transform
	GameEnv.get_current_session().input_block.set("book", true)
	_init_book_state(book_id, book, book_properties.is_gibberish)
	_render_pages([0, 1])
	await _controlled_book.book_entity.eject_from_shelf()
	await _controlled_book.book_entity.fly_to_camera(camera.global_transform)
	await _controlled_book.book_entity.open()
	Log.info("Book ", _controlled_book.book_id, " opened")

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
	Log.info("Book ", _controlled_book.book_id, " stop reading")
	_state_manager.save(_controlled_book.book_id, _controlled_book.book_state)
	await _controlled_book.book_entity.close()
	GameEnv.get_current_session().input_block.set("book", false)
	await _controlled_book.book_entity.fly_to_origin(_controlled_book.shelf_place_transform)
	# play return animation here
	# await animation end
	Signals.return_book.emit(_controlled_book.book_id)
	_entity_manager.destroy_entity(_controlled_book.book_id)
	Log.info("Book ", _controlled_book.book_id, " closed")
	_controlled_book.free()
	_controlled_book = null

func _turn_page(forward : bool = true):
	if _controlled_book:
		var book_size : int = _controlled_book.book_data.cached_book_size
		var current_index : int = _controlled_book.book_state.current_page
		if forward:
			if (current_index + 2) < book_size:
				_controlled_book.book_state.current_page = current_index + 2
				_render_pages([-2, 1, -1, 0])
				# render order: current page index 2
				# Rendered pages (from left to right) index: 0, 1, 2, 3 (in middle pages on animated page)
				_controlled_book.book_entity.set_page_visible(true)
				await _controlled_book.book_entity.turn_page(forward)
				_render_pages([0, 1])
				_controlled_book.book_entity.set_page_visible(false)
		else:
			if (current_index - 2) >= 0:
				_controlled_book.book_state.current_page = current_index - 2
				_render_pages([0, 3, 1, 2])
				_controlled_book.book_entity.set_page_visible(true)
				await _controlled_book.book_entity.turn_page(forward)
				_render_pages([0, 1])
				_controlled_book.book_entity.set_page_visible(false)

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
	if not _controlled_book:
		return
	var pages : Array[PageData] = _controlled_book.book_data.split()
	var current_page = _controlled_book.book_state.current_page
	var pages_for_render : Array[PageData] = []
	for offset in order:
		pages_for_render.append(pages.get(current_page + offset))
	_controlled_book.book_entity.render_pages(pages_for_render)
