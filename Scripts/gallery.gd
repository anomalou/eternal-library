@tool
extends Node
class_name Gallery

var _gallery_seed : int

var gallery_transform : HexagonTransform
var _gallery_gizmo : HexagonGizmo
var _spawnpoint_manager : SpawnPointManager

func _ready() -> void:
	self.gallery_transform = $HexagonTransform as HexagonTransform
	self._gallery_gizmo = $HexagonGizmo as HexagonGizmo
	self._spawnpoint_manager = $SpawnPointManager as SpawnPointManager
	
	_gallery_gizmo.setup(gallery_transform.hex_position, gallery_transform.height)

func apply_position(hex_position : HexCoord):
	self.gallery_transform.update(hex_position)
	self.position = gallery_transform.position.global_coord
	
func generate_gallery(_seed : int):
	self._gallery_seed = _seed
