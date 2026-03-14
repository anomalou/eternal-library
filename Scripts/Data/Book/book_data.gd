class_name BookData

var id
var chapters : Array[ChapterData]

func _init(_id : String, _chapters : Array[ChapterData]) -> void:
	self.id = _id
	self.chapters = _chapters

func split() -> Array[PageData]:
	var pages : Array[PageData] = []
	for chapter in chapters:
		pages.append_array(chapter.split())
	return pages
