extends ShaderMaterial
class_name ColorShader

func _init() -> void:
	shader = load("res://Shaders/color.gdshader")

func set_color(color : Color):
	set_shader_parameter("color", color)
