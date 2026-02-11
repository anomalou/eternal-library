shader_type canvas_item;

uniform float vignette_intensity = 1.0;
uniform vec4 vignette_color = vec4(0, 0, 0, 1);

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	float dist = distance(UV, center);
	float vignette = 1.0 - dist * vignette_intensity;
	vignette = clamp(vignette, 0.0, 1.0);
	
	COLOR = mix(vignette_color, texture(TEXTURE, UV), vignette);
}
