extends ShaderMaterial
class_name WobbleShader

func _init() -> void:
	shader = load("res://Shaders/vertex_wobble.gdshader")

func set_intensity(value : float):
	set_shader_parameter("intensity", value)

func set_speed(value : float):
	set_shader_parameter("speed", value)

func set_quant(value : float):
	set_shader_parameter("quant", value)

func set_color(color : Color):
	set_shader_parameter("color", color)
