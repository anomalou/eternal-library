extends Node
class_name ContentBuilder

@onready var left_page_builder : PageBuilder = $LeftPage/PageBuilder
@onready var right_page_generator : PageBuilder = $RightPage/PageBuilder

@onready var left_page : SubViewport = $LeftPage
@onready var right_page : SubViewport = $RightPage

func build_left():
	pass

func build_right():
	pass
