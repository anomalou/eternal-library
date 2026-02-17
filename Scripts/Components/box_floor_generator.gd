extends FloorGenerator
class_name BoxFloorGenerator

@export var floor_material : Material
@export var floor_texture : Texture
@export var texture_scale : float = 8.0

func generate(width : float, length : float, direction : Vector3):
	var plate = _generate_mesh(width, length, direction)
	_generate_collider(plate)

func _generate_mesh(width : float, length : float, direction : Vector3) -> MeshInstance3D:
	var plate = MeshInstance3D.new()
	
	var verticies = PackedVector3Array()
	var indices = PackedInt32Array()
	var uv = PackedVector2Array()
	
	var angle = direction.signed_angle_to(Vector3.RIGHT, Vector3.DOWN)
	
	verticies.append(Vector3(width * 0.5, 0, -length * 0.5))
	verticies.append(Vector3(-width * 0.5, 0, -length * 0.5))
	verticies.append(Vector3(-width * 0.5, 0, length * 0.5))
	verticies.append(Vector3(width * 0.5, 0, length * 0.5))
	
	indices.append_array([2, 1, 0])
	indices.append_array([3, 2, 0])
	
	var uv_x = 1.0
	var uv_y = 1.0
	
	if floor_texture and floor_texture.has_method("get_size"):
		var texture_size = floor_texture.get_size() as Vector2
		uv_x = width / texture_size.x * texture_scale
		uv_y = length / texture_size.y * texture_scale
	
	uv.append(Vector2(uv_x, 0))
	uv.append(Vector2(0, 0))
	uv.append(Vector2(0, uv_y))
	uv.append(Vector2(uv_x, uv_y))
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	
	array.set(Mesh.ARRAY_VERTEX, verticies)
	array.set(Mesh.ARRAY_INDEX, indices)
	array.set(Mesh.ARRAY_TEX_UV, uv)
	
	var material = floor_material.duplicate(true)
	if material is TextureShader:
		material.set_texture(floor_texture)
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	plate.mesh = mesh
	plate.rotate_y(angle)
	
	add_child(plate)
	plate.set_deferred("owner", self)
	
	return plate
	
