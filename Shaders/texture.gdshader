shader_type spatial;
render_mode unshaded;

uniform sampler2D sprite : filter_nearest;

void fragment() {
	ALBEDO = texture(sprite, UV).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
