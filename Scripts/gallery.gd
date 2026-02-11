@tool
extends Node3D
class_name Gallery

var id : String

var gallery_transform : HexagonTransform
var _gallery_gizmo : HexagonGizmo
var _spawnpoint_manager : SpawnPointManager
var _walls_generator : WallsGenerator
var _floor_generator : FloorGenerator

func _ready() -> void:
	self.gallery_transform = $HexagonTransform as HexagonTransform
	self._gallery_gizmo = $HexagonGizmo as HexagonGizmo
	self._spawnpoint_manager = $SpawnPointManager as SpawnPointManager
	self._walls_generator = $WallsGenerator as WallsGenerator
	self._floor_generator = $FloorGenerator as FloorGenerator

func setup(_id : String):
	self.id = _id
	print_debug("Gallery " + gallery_transform.hex_position.to_str() + " is ready")

func apply_position(hex_position : HexCoord):
	self.gallery_transform.hex_position = hex_position
	_gallery_gizmo.setup(gallery_transform.hex_position, gallery_transform.height)
	_walls_generator.setup(id, gallery_transform.hex_position, gallery_transform.height)
	_floor_generator.setup(gallery_transform.hex_position, gallery_transform.height)
	self.position = gallery_transform.hex_position.global_coord
	
func generate_gallery(_id : String):
	self.id = _id
	#self._walls_generator.generate([])
	self._floor_generator.generate()

func context():
	return gallery_transform.hex_position.to_str()
