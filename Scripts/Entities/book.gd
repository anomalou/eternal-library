extends Entity
class_name Book

@warning_ignore("unused_signal")
signal initialization_done()
@warning_ignore("unused_signal")
signal ready_to_read()

@onready var left_folder : MeshInstance3D = $Mesh/left_folder
@onready var right_folder : MeshInstance3D = $Mesh/right_folder
@onready var spine : MeshInstance3D = $Mesh/spine
@onready var page : MeshInstance3D = $Mesh/page

@onready var block_content_builder : ContentBuilder = $BlockContentBuilder
@onready var page_content_builder : ContentBuilder = $PageContentBuilder
@onready var left_block : MeshInstance3D = $Mesh/left_block
@onready var right_block : MeshInstance3D = $Mesh/right_block

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree

@export var folder_material : StandardMaterial3D
@export var paper_material : StandardMaterial3D
@export var text_material : StandardMaterial3D

func generate(_id : String):
	self.id = _id
#	Left and right pages blocks of book
	var left_block_material = paper_material.duplicate(true)
	var right_block_material = paper_material.duplicate(true)
	
	left_block.mesh.surface_set_material(1, left_block_material)
	right_block.mesh.surface_set_material(1, right_block_material)
	
	left_block_material.next_pass = text_material.duplicate(true)
	right_block_material.next_pass = text_material.duplicate(true)
	
	left_block_material.next_pass.albedo_texture = block_content_builder.left_page.get_texture()
	right_block_material.next_pass.albedo_texture = block_content_builder.right_page.get_texture()
	
#	Thick page that play turn animation
	var left_page_material = paper_material.duplicate(true)
	var right_page_material = paper_material.duplicate(true)
	
	page.mesh.surface_set_material(1, left_page_material)
	page.mesh.surface_set_material(0, right_page_material)
	
	left_page_material.next_pass = text_material.duplicate(true)
	right_page_material.next_pass = text_material.duplicate(true)
	
	left_page_material.next_pass.albedo_texture = page_content_builder.left_page.get_texture()
	right_page_material.next_pass.albedo_texture = page_content_builder.right_page.get_texture()
	
	page.visible = false

# only takes 2 first pages
func render_pages(pages : Array[PageData]):
	block_content_builder.build([pages.get(0), pages.get(1)])
	if pages.size() > 2:
		page_content_builder.build([pages.get(2), pages.get(3)])

func set_color(color : Color):
	var _folder_material : StandardMaterial3D = folder_material.duplicate(true)
	_folder_material.albedo_color = color
	left_folder.set_surface_override_material(0, _folder_material)
	right_folder.set_surface_override_material(0, _folder_material)
	spine.set_surface_override_material(0, _folder_material)

func open():
	var book_state : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/BookState/playback")
	book_state.travel("open_book")
	var state = ""
	while state != "open_book":
		state = await book_state.state_finished

func close():
	var book_state : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/BookState/playback")
	book_state.travel("close_book")
	var state = ""
	while state != "close_book":
		state = await book_state.state_finished

func set_page_visible(visibility : bool = true):
	page.visible = visibility

func turn_page(forward : bool):
	var turn_state : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/TurnState/playback")
	if forward:
		turn_state.start("turn_page_forward")
	else:
		turn_state.start("turn_page_backward")
	await turn_state.state_finished

func eject_from_shelf():
	var tween : Tween = create_tween()
	tween.tween_property(self, "global_position", global_transform * Vector3(-2.0, 0.0, 0.0), 0.1)
	await tween.finished


func fly_to_camera(camera_transf : Transform3D):
	var target_pos : Vector3 = camera_transf.origin - camera_transf.basis.z * 1.55 + camera_transf.basis.x * 0.35
	var target = Transform3D(camera_transf.basis, target_pos)
	
	var tween = fly_to_transf(target)
	await tween.finished

func fly_to_shelf(shelf_transf : Transform3D):
	var tween = fly_to_transf(shelf_transf)
	await tween.finished

func fly_to_transf(transf : Transform3D) -> Tween:
	var dist_to_target = self.position.distance_to(transf.origin)
	var duration = clamp(dist_to_target, 0.1, 0.3)
	
	var tween : Tween = create_tween()
	tween.tween_property(self, "global_transform", transf, duration)
	return tween

func _generate_color():
	var color_id = _seed_manager.generate_object_id("color", "", id)
	var rnd = _seed_manager.get_temp_rnd(color_id)
	var h = rnd.randf()
	var s = rnd.randf_range(0.5, 0.8)
	var v = rnd.randf_range(0.5, 0.6)
	var color = Color.from_hsv(h, s, v)
	return color
