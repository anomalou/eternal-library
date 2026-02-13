@tool
extends Node3D
class_name Gallery

var id : String
var type : EnumTypes.GalleryType

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
	

func _apply_position(hex_position : HexCoord):
	self.hex_transform.hex_position = hex_position
	_gallery_gizmo.setup(hex_transform.hex_position, hex_transform.height)
	_walls_generator.setup(id, hex_transform.hex_position, hex_transform.height)
	_floor_generator.setup(hex_transform.hex_position)
	_ceil_generator.setup(hex_transform.hex_position, hex_transform.height)
	self.position = hex_transform.hex_position.global_coord
	
func generate_gallery(_id : String, hex_position : HexCoord, entrances : Array[EnumTypes.Direction] = []):
	self.id = _id
	_apply_position(hex_position)
	#self._walls_generator.generate(entrances)
	self._floor_generator.generate()
	self._ceil_generator.generate()
	print_debug("Gallery ", hex_transform.hex_position.to_str(), " is ready with id = ", _id)
