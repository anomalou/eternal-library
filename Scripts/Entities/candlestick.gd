extends Entity

@export var base_energy : float = 8.0
@export var flicker_speed : float = 0.1

var base_position

@onready var light : OmniLight3D = $Light

func _ready() -> void:
	base_position = light.position

func _process(_delta: float) -> void:
	var target = base_energy + randf_range(-6, 2)
	light.light_energy = lerp(light.light_energy, target, flicker_speed)
	
	var offset = Vector3(
		randf_range(-0.2, 0.2),
		randf_range(-0.2, 0.2),
		randf_range(-0.2, 0.2)
	)
	light.position = lerp(light.position, base_position + offset, flicker_speed)
