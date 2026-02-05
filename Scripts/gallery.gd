@tool
extends Node3D
class_name Gallery

var _gallery_seed : int

var gallery_transform : HexagonTransform
var _gallery_gizmo : HexagonGizmo
var _spawnpoint_manager : SpawnPointManager
var _walls_manager : WallsManager

func _ready() -> void:
	self.gallery_transform = $HexagonTransform as HexagonTransform
	self._gallery_gizmo = $HexagonGizmo as HexagonGizmo
	self._spawnpoint_manager = $SpawnPointManager as SpawnPointManager
	self._walls_manager = $WallsManager as WallsManager
	
	_gallery_gizmo.setup(gallery_transform.hex_position, gallery_transform.height)
	_walls_manager.setup(gallery_transform.hex_position, gallery_transform.height)
	print_debug("Gallery " + gallery_transform.hex_position.to_str() + " is ready")

func apply_position(hex_position : HexCoord):
	self.gallery_transform.hex_position = hex_position
	self.position = gallery_transform.hex_position.global_coord
	
func generate_gallery(_seed : int):
	self._gallery_seed = _seed
	self._walls_manager.generate()
