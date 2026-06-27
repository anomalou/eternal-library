shader_type canvas_item;

uniform float vignette_intensity = 1.0;
uniform float vignette_radius = 0.5;
uniform vec4 vignette_color = vec4(0, 0, 0, 1);
uniform float color_levels = 8.0;
uniform float noise_strength = 0.01;
uniform float pixel_size = 4.0;
uniform vec2 screen_resolution = vec2(1280.0, 720.0);

void fragment() {
	vec2 pixel_count = screen_resolution / pixel_size;
	vec2 pixelated_uv = floor(UV * pixel_count) / pixel_count;

	vec4 color = texture(TEXTURE, pixelated_uv);

    color.rgb = floor(color.rgb * color_levels) / color_levels;

	float noise = fract(sin(dot(UV + TIME * 0.1, vec2(127.1, 311.7))) * 43758.5453);
    color.rgb += (noise - 0.5) * noise_strength;

	vec2 center = vec2(0.5, 0.5);
	float dist = distance(UV, center);
	float vignette = 1.0 - smoothstep(vignette_radius, vignette_radius + vignette_intensity * 0.5, dist);

	COLOR = mix(vignette_color, color, vignette);
}
