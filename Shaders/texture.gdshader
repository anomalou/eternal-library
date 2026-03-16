shader_type spatial;
render_mode blend_mix, cull_back;

uniform sampler2D sprite : filter_nearest;

void fragment() {
	ALBEDO = texture(sprite, UV).rgb;
}
