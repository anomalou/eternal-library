extends Component
class_name HexCeilGenerator

@export var ceil_material : ShaderMaterial

var _position : HexCoord
var _height : float = 32.0

func setup(pos : HexCoord, height : float):
	self._position = pos
	self._height = height

func generate():
	if not self.ceil_material:
		push_error("Cant generate ceil cause shader material not provided")
		return
	
	_generate_hex(self.ceil_material, self._height, Color.DEEP_SKY_BLUE, false)

func _generate_hex(material : Material, height : float, color : Color = Color.WHITE, clockwise : bool = true) -> MeshInstance3D:
	var hex = MeshInstance3D.new()
	
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	vertices.append(Vector3(0, height, 0))
	
	for i in range(7):
		var angle = deg_to_rad(60 * i)
		vertices.append(Vector3(
			_position.size * cos(angle),
			height,
			_position.size * sin(angle)
		))
	
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
	
	var _material = material.duplicate(true) as ColorShader
	_material.set_color(color)
	
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, _material)
	
	hex.mesh = mesh
	
	add_child(hex)
	hex.set_deferred("owner", self)
	
	return hex
