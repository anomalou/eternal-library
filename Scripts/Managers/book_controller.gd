extends Node
class_name BookController

var _entity_manager : EntityManager
var _book_manager : BookManager

var _book_id : String
var _book_entity : Book
var _book_data : BookData

func _ready() -> void:
	Signals.select_book.connect(_control_book)

# Also need state manager here 
func init(entity_manager : EntityManager, book_manager : BookManager):
	self._entity_manager = entity_manager
	self._book_manager = book_manager
	Log.info("Book controller initialized")

func _control_book(book_id : String):
	var entity = _entity_manager.find(book_id)
	var data = _book_manager.find(book_id)
	if not entity or not entity is Book or not data:
		Log.error("Something wrong with book = ", book_id)
	else:
		self._book_id = book_id
		self._book_entity = entity
		self._book_data = _book_manager.find(book_id)
		
		# only for tests
		_render_pages()

# only usable when book is open. Book state will be in state manager
# also state manager handle current opened page
func _render_pages():
	if not _book_id:
		return
	var pages : Array[PageData] = _book_data.split()
	_book_entity.render_pages(pages)
