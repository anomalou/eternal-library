extends Entity
class_name Book

@warning_ignore("unused_signal")
signal initialization_done()
@warning_ignore("unused_signal")
signal ready_to_read()

@onready var left_folder : MeshInstance3D = $Mesh/left_folder
@onready var right_folder : MeshInstance3D = $Mesh/right_folder
@onready var spine : MeshInstance3D = $Mesh/spine

@onready var content_builder : ContentBuilder = $ContentBuilder
@onready var left_page : MeshInstance3D = $Mesh/left_block
@onready var right_page : MeshInstance3D = $Mesh/right_block

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree

@export var folder_material : StandardMaterial3D
@export var paper_material : StandardMaterial3D
@export var text_material : StandardMaterial3D

func generate(_id : String):
	self.id = _id
	var left_material = paper_material.duplicate(true)
	var right_material = paper_material.duplicate(true)
	
	left_page.mesh.surface_set_material(1, left_material)
	right_page.mesh.surface_set_material(1, right_material)
	
	left_material.next_pass = text_material.duplicate(true)
	right_material.next_pass = text_material.duplicate(true)
	
	left_material.next_pass.albedo_texture = content_builder.left_page.get_texture()
	right_material.next_pass.albedo_texture = content_builder.right_page.get_texture()

# only takes 2 first pages
func render_pages(pages : Array[PageData]):
	pages.resize(2)
	content_builder.build(pages)

func set_color(color : Color):
	var _folder_material : StandardMaterial3D = folder_material.duplicate(true)
	_folder_material.albedo_color = color
	left_folder.set_surface_override_material(0, _folder_material)
	right_folder.set_surface_override_material(0, _folder_material)

func open():
	var book_state : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/BookState/playback")
	book_state.travel("open_book")
	await animation_player.animation_finished

func close():
	var book_state : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/BookState/playback")
	book_state.travel("close_book")
	await animation_player.animation_finished

func _generate_color():
	var color_id = _seed_manager.generate_object_id("color", "", id)
	var rnd = _seed_manager.get_temp_rnd(color_id)
	var h = rnd.randf()
	var s = rnd.randf_range(0.5, 0.8)
	var v = rnd.randf_range(0.5, 0.6)
	var color = Color.from_hsv(h, s, v)
	return color
