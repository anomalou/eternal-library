extends Node
class_name ContentBuilder

@onready var left_page_builder : PageBuilder = $LeftPage/PageBuilder
@onready var right_page_generator : PageBuilder = $RightPage/PageBuilder

@onready var left_page : SubViewport = $LeftPage
@onready var right_page : SubViewport = $RightPage

func build(pages : Array[PageData]):
	left_page_builder.build(pages.get(0))
	right_page_generator.build(pages.get(1))
