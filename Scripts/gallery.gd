@tool
extends Node3D
class_name Gallery

var id : String

var hex_transform : HexagonTransform
var _gallery_gizmo : HexagonGizmo
var _spawnpoint_manager : SpawnPointManager
var _walls_generator : WallsGenerator
var _floor_generator : FloorGenerator
var _ceil_generator : CeilGenerator

func _ready() -> void:
	self.hex_transform = $HexagonTransform as HexagonTransform
	self._gallery_gizmo = $HexagonGizmo as HexagonGizmo
	self._spawnpoint_manager = $SpawnPointManager as SpawnPointManager
	self._walls_generator = $WallsGenerator as WallsGenerator
	self._floor_generator = $FloorGenerator as FloorGenerator
	self._ceil_generator = $CeilGenerator as CeilGenerator
	

func setup(_id : String):
	self.id = _id
	print_debug("Gallery " + hex_transform.hex_position.to_str() + " is ready")

func apply_position(hex_position : HexCoord):
	self.hex_transform.hex_position = hex_position
	_gallery_gizmo.setup(hex_transform.hex_position, hex_transform.height)
	_walls_generator.setup(id, hex_transform.hex_position, hex_transform.height)
	_floor_generator.setup(hex_transform.hex_position)
	_ceil_generator.setup(hex_transform.hex_position, hex_transform.height)
	self.position = hex_transform.hex_position.global_coord
	
func generate_gallery(_id : String):
	self.id = _id
	#self._walls_generator.generate([])
	self._floor_generator.generate()
	self._ceil_generator.generate()

func context():
	return hex_transform.hex_position.to_str()
