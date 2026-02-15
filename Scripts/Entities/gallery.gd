@tool
extends Entity
class_name Gallery

var type : EnumTypes.GalleryType

var hex_transform : HexagonTransform
var _gallery_gizmo : HexagonGizmo
var _spawnpoint_manager : SpawnPointManager
var _walls_generator : HexWallsGenerator
var _floor_generator : HexFloorGenerator
var _ceil_generator : HexCeilGenerator

func _ready() -> void:
	self.hex_transform = $HexagonTransform as HexagonTransform
	self._gallery_gizmo = $HexagonGizmo as HexagonGizmo
	self._spawnpoint_manager = $SpawnPointManager as SpawnPointManager
	self._walls_generator = $WallsGenerator as HexWallsGenerator
	self._floor_generator = $FloorGenerator as HexFloorGenerator
	self._ceil_generator = $CeilGenerator as HexCeilGenerator
	

func _apply_position(hex_position : HexCoord):
	self.hex_transform.hex_position = hex_position
	_gallery_gizmo.setup(hex_transform.hex_position, hex_transform.height)
	_walls_generator.setup(id, hex_transform.hex_position, hex_transform.height)
	_floor_generator.setup(hex_transform.hex_position)
	_ceil_generator.setup(hex_transform.hex_position, hex_transform.height)
	self.position = hex_transform.hex_position.global_coord
	
func generate(_id : String, hex_position : HexCoord, entrances : Array[EnumTypes.Direction] = []):
	self.id = _id
	_apply_position(hex_position)
	self._walls_generator.generate(entrances)
	self._floor_generator.generate()
	self._ceil_generator.generate()
	print_debug("Gallery ", hex_transform.hex_position.to_str(), " is ready with id = ", _id)

func regenerate(entrances : Array[EnumTypes.Direction]):
	if not id or id.is_empty():
		push_error("Cannot regenerate gallery that not generated yet")
		return
	self._walls_generator.regenerate(entrances)
	print_debug("Gallery ", hex_transform.hex_position.to_str(), " regenerated")
