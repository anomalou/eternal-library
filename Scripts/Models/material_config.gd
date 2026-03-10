extends Node3D
class_name MaterialConfig

@export var materials : Array[Material]

var cached_mesh : MeshInstance3D

func _ready() -> void:
	for mesh : MeshInstance3D in find_children("*", "MeshInstance3D"):
		cached_mesh = mesh 
		for i in range(materials.size()):
			if materials.get(i):
				var material = materials.get(i).duplicate(true)
				mesh.set_surface_override_material(i, material)

func set_color(color : Color, surface : int):
	var material = cached_mesh.get_surface_override_material(surface)
	if material is StandardMaterial3D:
		material.albedo_color = color
