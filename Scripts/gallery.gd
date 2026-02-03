@tool
extends Node
class_name Gallery

var gallery_transform : HexagonTransform
var gallery_gizmo : HexagonGizmo

func _ready() -> void:
	self.gallery_transform = $HexagonTransform as HexagonTransform
	self.gallery_gizmo = $HexagonGizmo as HexagonGizmo
	
	gallery_gizmo.setup(gallery_transform.hex_position)

func apply_position(hex_position : HexCoord):
	self.gallery_transform.update(hex_position)
	self.position = gallery_transform.position.global_coord
