shader_type spatial;
render_mode cull_back, blend_mix;

uniform vec4 color = vec4(1, 1, 1, 1);

void fragment() {
	ALBEDO = color.rgb;
	ALPHA = 1.0;
}

//void light() {
	//DIFFUSE_LIGHT = LIGHT_COLOR * ATTENUATION;
//}