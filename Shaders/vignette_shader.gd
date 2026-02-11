extends ShaderMaterial
class_name VignetteShader

func _init() -> void:
	shader = load("res://Shaders/vignette_posteffect.gdshader")

func set_vignette_intensity(value : float):
	set_shader_parameter("vignette_intensity", value)

func set_vignette_color(color : Color):
	set_shader_parameter("vignette_color", color)
