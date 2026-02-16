extends ShaderMaterial
class_name TextureShader

func _init() -> void:
	shader = load("res://Shaders/texture.gdshader")
	

func set_texture(_texture : Texture):
	set_shader_parameter("sprite", _texture)
