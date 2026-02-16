extends WallGenerator
class_name BoxWallsGenerator

@export var walls_material : Material

func generate(height : float, length : float, spacing : float, direction : Vector3):
	var basis_angle = direction.signed_angle_to(Vector3.RIGHT, Vector3.DOWN)
	_generate_plate(height, length, basis_angle + deg_to_rad(90), spacing * 0.5)
	_generate_plate(height, length, basis_angle - deg_to_rad(90), spacing * 0.5)

func _generate_plate(height : float, length : float, angle : float = 0.0, offset : float = 0.0):
	var plate : MeshInstance3D = MeshInstance3D.new()
	
	var mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var center = Vector3(offset, height * 0.5, 0)
	
	vertices.append(Vector3(center.x, height, center.z - length * 0.5))
	vertices.append(Vector3(center.x, 0, center.z - length * 0.5))
	vertices.append(Vector3(center.x, 0, center.z + length * 0.5))
	vertices.append(Vector3(center.x, height, center.z + length * 0.5))
	
	indices.append_array([0, 2, 1])
	indices.append_array([0, 3, 2])
	
	var material = walls_material.duplicate(true)
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array.set(Mesh.ARRAY_VERTEX, vertices)
	array.set(Mesh.ARRAY_INDEX, indices)
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	plate.mesh = mesh
	plate.rotate_y(angle)
	
	add_child(plate)
	plate.set_deferred("owner", self)
