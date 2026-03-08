shader_type canvas_item;

uniform float vignette_intensity = 1.0;
uniform float vignette_radius = 0.5;
uniform vec4 vignette_color = vec4(0, 0, 0, 1);

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	float dist = distance(UV, center);
	float vignette = 1.0 - smoothstep(vignette_radius, vignette_radius + vignette_intensity * 0.5, dist);
	
	COLOR = mix(vignette_color, texture(TEXTURE, UV), vignette);
}
