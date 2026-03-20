extends CharacterBody3D
class_name PlayerController

@export var speed : float = 5.0
@export var mouse_sens : float = 0.003

var look_x : float = 0.0
var look_y : float = 0.0

@onready var _camera : Camera3D = $FPV
@onready var _raycast : RayCast3D = $FPV/RayCast3D

var interaction_collider : InteractableArea
var interact_point : Vector3

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sens)
		look_y = rotation.y
		look_x -= event.relative.y * mouse_sens
		look_x = clamp(look_x, -1.5, 1.5)
		_camera.rotation.x = look_x
	
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			get_tree().quit()
	
	if Input.is_action_just_pressed("use"):
		if interaction_collider:
			interaction_collider.interact.emit(interact_point)
	
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	if _raycast.is_colliding():
		var collide_point = _raycast.get_collision_point()
		var collider = _raycast.get_collider()
		if collider and collider is InteractableArea:
			interaction_collider = collider
			interact_point = collide_point
		else:
			interaction_collider = null
		Log.info("Raycast collision: ", collide_point)

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if not is_on_floor():
		velocity.y -= 9.8 * _delta
	
	move_and_slide()
	
