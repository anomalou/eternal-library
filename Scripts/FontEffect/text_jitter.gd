@tool
class_name RichTextTextJitter
extends RichTextEffect

var bbcode = "jitter"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var level : float = char_fx.env.get("level", 0.0)
	var rotation_level : float = char_fx.env.get("rotation", 0.0)
	var font_size : float = char_fx.env.get("size", 29.0)
	
	var seed_y = (char_fx.range.x + 1) * 311.7
	var seed_r = (char_fx.range.x + 1) * 213.7

	var rotation = (fract(sin(seed_r) * 43758.5453) - 0.5) * rotation_level
	char_fx.offset.y += (fract(sin(seed_y) * 43758.5453) - 0.5) * level
	
	var center = char_fx.transform.get_origin() + Vector2(15 * 0.5, font_size * 0.5)
	char_fx.transform = char_fx.transform.translated(-center).rotated(rotation).translated(center)
	
	return true

func fract(x: float) -> float:
	return x - floor(x)
