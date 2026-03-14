extends Node
class_name BookManager

var _seed_manager : SeedManager

var _book_cache : Dictionary[String, BookData]

func init(seed_manager : SeedManager):
	self._seed_manager = seed_manager
	Log.info("Book manager initialized")

func find(id : String):
	return _book_cache.get(id)

func generate_player_journal(player_id : String) -> String:
	var journal_id = _seed_manager.generate_object_id("player_journal", "", player_id)
	var notes : NotesChapter = NotesChapter.new(
		"Phasellus molestie tellus ut nibh luctus, a venenatis dolor dignissim. Donec nisi justo, euismod lacinia risus ac, euismod facilisis elit. Donec malesuada tincidunt ipsum sed aliquet. Fusce dapibus, ligula vitae aliquet iaculis, ligula sapien laoreet ipsum, sit amet consectetur ex enim ac velit. Quisque egestas dolor sit amet hendrerit fringilla."
	)
	var book : BookData = BookData.new(journal_id, [notes])
	_book_cache.set(journal_id, book)
	return journal_id
	

func generate_book(id : String):
	pass
