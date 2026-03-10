extends Entity
class_name Book

@onready var material : MaterialConfig = $Mesh

func generate(_id : String):
	self.id = _id
	_generate_color()

func generate_content():
	Log.info(id, " book content generated")

func _generate_color():
	var color_id = _seed_manager.generate_object_id("color", "", id)
	var rnd = _seed_manager.get_temp_rnd(color_id)
	var h = rnd.randf()
	var s = rnd.randf_range(0.5, 0.8)
	var v = rnd.randf_range(0.5, 0.6)
	var color = Color.from_hsv(h, s, v)
	material.set_color(color, 0)
