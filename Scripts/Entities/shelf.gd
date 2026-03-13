extends Entity
class_name Shelf

@export var book_number : int = 24
@export var book_prop : ArrayMesh
var taken_books : Array[int]

var multimesh : MultiMesh

func generate(_id : String):
	self.id = _id
	_generate_multimesh()
	#Log.info(id, " prop shelf generated")

func _generate_multimesh():
	var multimesh_instance : MultiMeshInstance3D = MultiMeshInstance3D.new()
	multimesh = MultiMesh.new()
	multimesh.mesh = book_prop
	multimesh.use_colors = true
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = book_number
	
	for i in range(book_number):
		var offset_id = _seed_manager.generate_object_id("offset", str(i), id)
		var rnd = _seed_manager.get_temp_rnd(offset_id)
		
		var inst_transform : Transform3D = Transform3D()
		inst_transform.origin = Vector3(0.5 + i, 0, rnd.randf_range(0, 0.4))
		inst_transform.basis = Basis(Vector3.UP, PI / 2)
		multimesh.set_instance_transform(i, inst_transform)
		multimesh.set_instance_color(i, _generate_color(i))
	
	multimesh_instance.multimesh = multimesh
	
	add_child(multimesh_instance)
	multimesh_instance.set_deferred("owner", self)
	

func _generate_color(index : int):
	var color_id = _seed_manager.generate_object_id("color", str(index), id)
	var rnd = _seed_manager.get_temp_rnd(color_id)
	var h = rnd.randf()
	var s = rnd.randf_range(0.5, 0.8)
	var v = rnd.randf_range(0.5, 0.6)
	var color = Color.from_hsv(h, s, v)
	return color
