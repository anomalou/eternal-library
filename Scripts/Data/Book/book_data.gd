class_name BookData

var id
var chapters : Array[ChapterData]
var cached_book_size : int

func _init(_id : String, _chapters : Array[ChapterData]) -> void:
	self.id = _id
	self.chapters = _chapters

func split() -> Array[PageData]:
	var pages : Array[PageData] = []
	var last_page_index = 0
	for chapter in chapters:
		var chapter_last_page_index
		for page in chapter.split():
			page.index = page.index + last_page_index
			chapter_last_page_index = page.index
			pages.append(page)
		last_page_index = chapter_last_page_index
	cached_book_size = pages.size()
	return pages
