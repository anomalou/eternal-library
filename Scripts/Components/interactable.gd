extends Component
class_name Interactable

@onready var _area : CollisionShape3D = $Area3D/CollisionShape3D 

func configure_area(size : Vector3, offset : Vector3):
	var box : BoxShape3D = _area.shape
	box.size = size
	_area.position = offset
	
