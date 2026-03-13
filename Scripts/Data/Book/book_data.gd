class_name BookData

var id
var page_number : int
var current_page : int
var pages : Array

func _init(_page_number : int, _pages : Array) -> void:
	self.page_number = _page_number
	self.pages = _pages
	self.current_page = 0

func next_page():
	if (current_page + 2) > page_number:
		return
	else:
		current_page = current_page + 2

func prev_page():
	if (current_page - 2) < 0:
		return
	else:
		current_page = current_page - 2

func get_left_page():
	pages.get(current_page)

func get_right_page():
	if (current_page + 1) >= page_number:
		return EmptyPage.new()
	else:
		pages.get(current_page + 1)
