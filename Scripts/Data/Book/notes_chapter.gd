extends ChapterData
class_name NotesChapter

var text : String

func _init(_text : String) -> void:
	self.text = _text

func calculate_size() -> int:
	return -1

func split() -> Array[PageData]:
	var pages : Array[PageData] = []
	var words : PackedStringArray = text.split(" ", false)
	while not words.is_empty():
		var char_number = 0
		var page_words = []
		for word in words:
			char_number = char_number + word.length()
			if char_number < Constants.NOTE_PAGE_SIZE:
				page_words.append(word)
			else:
				break
		words = words.slice(page_words.size(), words.size())
		var page : NotePage = NotePage.new()
		page.text = " ".join(page_words)
		page.index = pages.size() + 1
		pages.append(page)
	if pages.size() % 2 != 0:
		pages.append(EmptyPage.new(pages.size() + 1))
	return pages
