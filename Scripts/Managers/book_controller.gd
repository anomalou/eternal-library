extends Node
class_name BookController

var _entity_manager : EntityManager
var _state_manager : StateManager
var _book_manager : BookManager

var _book_id : String
var _book_entity : Book
var _book_data : BookData
var _book_state : BookState

func _ready() -> void:
	Signals.select_book.connect(_control_book)

# Also need state manager here 
func init(entity_manager : EntityManager, state_manager : StateManager, book_manager : BookManager):
	self._entity_manager = entity_manager
	self._state_manager = state_manager
	self._book_manager = book_manager
	Log.info("Book controller initialized")

func _control_book(book_id : String):
	var entity = _entity_manager.find(book_id)
	var data = _book_manager.find(book_id)
	if not entity or not entity is Book or not data:
		Log.error("Something wrong with book = ", book_id)
	else:
		var state
		if _state_manager.has_state(book_id):
			state = _state_manager.restore(book_id)
		
		if not state or not state is BookData:
			state = BookState.new()
			state.current_page = 0
			_state_manager.save(book_id, state)
		
		self._book_id = book_id
		self._book_entity = entity
		self._book_data = data
		self._book_state = state
		
		# only for tests
		_render_pages()

func _turn_page(forward : bool = true):
	if _book_id:
		var book_size : int = _book_data.cached_book_size
		var current_index : int = _book_state.current_page
		if forward:
			if (current_index + 2) < book_size:
				_book_state.current_page = current_index + 2
				_render_pages()
		else:
			if (current_index - 2) >= 0:
				_book_state.current_page = current_index - 2
				_render_pages()

# only usable when book is open. Book state will be in state manager
# also state manager handle current opened page
func _render_pages():
	if not _book_id:
		return
	var pages : Array[PageData] = _book_data.split()
	var current_page = _book_state.current_page
	pages = pages.slice(current_page, pages.size())
	_book_entity.render_pages(pages)
