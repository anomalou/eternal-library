extends Node3D
class_name BoxWallsGenerator

@export var walls_material : Material

func generate(height : float, length : float, direction : Vector3):
	_generate_plate(height, length)

func _generate_plate(height : float, length : float, angle : float = 0.0, offset : float = 0.0):
	var plate : MeshInstance3D = MeshInstance3D.new()
	
	var mesh = ArrayMesh.new()
	var verticies = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var rad_angle = deg_to_rad(angle)
	var center = Vector3(cos(rad_angle) * offset, height * 0.5, sin(rad_angle) * offset)
	
	var material = walls_material.duplicate(true)
	mesh.material = material
	
	add_child(plate)
	plate.set_deferred("owner", self)
