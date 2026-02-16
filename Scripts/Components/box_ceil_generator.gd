extends Component
class_name BoxCeilGenerator

@export var ceil_material : Material

func generate(width : float, length : float, height : float, direction : Vector3):
	var plate = MeshInstance3D.new()
	
	var verticies = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var angle = direction.signed_angle_to(Vector3.RIGHT, Vector3.DOWN)
	
	verticies.append(Vector3(width / 2, height, -length / 2))
	verticies.append(Vector3(-width / 2, height, -length / 2))
	verticies.append(Vector3(-width / 2, height, length / 2))
	verticies.append(Vector3(width / 2, height, length / 2))
	
	indices.append_array([0, 1, 2])
	indices.append_array([0, 2, 3])
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	
	array.set(Mesh.ARRAY_VERTEX, verticies)
	array.set(Mesh.ARRAY_INDEX, indices)
	
	var material = ceil_material.duplicate(true)
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	plate.mesh = mesh
	plate.rotate_y(angle)
	
	add_child(plate)
	plate.set_deferred("owner", self)
