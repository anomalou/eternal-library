extends Component
class_name Interactable

@onready var _area : InteractableArea = $Area3D
@onready var _collision : CollisionShape3D = $Area3D/CollisionShape3D

func connect_action(callback : Callable):
	_area.interact.connect(callback)

func configure_area(size : Vector3, offset : Vector3):
	var box : BoxShape3D = _collision.shape
	box.size = size
	_collision.position = offset
