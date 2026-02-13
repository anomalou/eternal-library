extends Node3D
class_name Observer

var speed : float = 1.0
@export var mouse_sens : float = 0.003
var is_rotate = false

var _look_x : float = 0.0

@onready var _camera : Camera3D = $FPV

func _input(event: InputEvent) -> void:
	if is_rotate:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			is_rotate = event.pressed
	
	if event is InputEventMouseMotion and is_rotate:
		rotate_y(-event.relative.x * mouse_sens)
		_look_x -= event.relative.y * mouse_sens
		_look_x = clamp(_look_x, -1.5, 1.5)
		_camera.rotation.x = _look_x
		
		
