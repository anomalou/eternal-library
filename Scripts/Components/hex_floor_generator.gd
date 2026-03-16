extends FloorGenerator
class_name HexFloorGenerator

@export var material : Material

var _position : HexCoord

func setup(_id : String, pos : HexCoord):
	self.id = _id
	self._position = pos

func generate():
	if not self.material:
		push_error("Cant generate floor cause material not provided")
		return
	
	var _floor = _generate_hex(0) as MeshInstance3D
	_generate_collider(_floor)

func _generate_hex(depth : int = 0, clockwise : bool = true) -> MeshInstance3D:
	var hex = MeshInstance3D.new()
	
	var vertices = PackedVector3Array()
	var uv = PackedVector2Array()
	var indices = PackedInt32Array()
	var normals = PackedVector3Array()
	
	var rnd = _seed_manager.get_temp_rnd(id)
	var rnd_texture_diff = rnd.randf() * PI
	var normal = Vector3.UP if clockwise else Vector3.DOWN
	
	vertices.append(Vector3(0, depth, 0))
	uv.append(Vector2.ZERO)
	normals.append(normal)
	
	for i in range(7):
		var angle = deg_to_rad(60 * i)
		vertices.append(Vector3(
			_position.size * cos(angle),
			depth,
			_position.size * sin(angle)
		))
		uv.append(Vector2(cos(angle + rnd_texture_diff), sin(angle + rnd_texture_diff)))
		normals.append(normal)
	
	for i in range(6):
		if clockwise:
			indices.append(0)
			indices.append(i + 1)
			indices.append(i + 2)
		else:
			indices.append(i + 2)
			indices.append(i + 1)
			indices.append(0)
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	array[Mesh.ARRAY_TEX_UV] = uv
	array[Mesh.ARRAY_NORMAL] = normals
	
	var _material = material.duplicate(true)
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, _material)
	
	hex.mesh = mesh
	
	add_child(hex)
	hex.set_deferred("owner", self)
	
	return hex
