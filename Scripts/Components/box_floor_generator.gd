extends Node3D
class_name BoxFloorGenerator

@export var floor_material : Material

func generate(g1 : HexCoord, g2 : HexCoord):
	var plate = MeshInstance3D.new()
	
	var verticies = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var v1 = g1.global_coord as Vector3
	var v2 = g2.global_coord as Vector3
	var direction = v2 - v1
	
	var angle = direction.signed_angle_to(Vector3.RIGHT, Vector3.DOWN)
	var width = g1.size
	var lenght = g1.spacing
	
	verticies.append(Vector3(width / 2, 0, -lenght / 2))
	verticies.append(Vector3(-width / 2, 0, -lenght / 2))
	verticies.append(Vector3(-width / 2, 0, lenght / 2))
	verticies.append(Vector3(width / 2, 0, lenght / 2))
	
	indices.append_array([2, 1, 0])
	indices.append_array([3, 2, 0])
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	
	array.set(Mesh.ARRAY_VERTEX, verticies)
	array.set(Mesh.ARRAY_INDEX, indices)
	
	var material = floor_material.duplicate(true)
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	plate.mesh = mesh
	plate.rotate_y(angle)
	
	add_child(plate)
	plate.set_deferred("owner", self)
