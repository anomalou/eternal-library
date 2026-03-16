shader_type spatial;

uniform vec4 color : source_color = vec4(1, 1, 1, 1);
uniform float noise_strength = 0.1;
uniform float noise_seed = 0.0;
uniform float pixel_size = 64.0;

varying vec3 world_pos;
varying vec3 world_normal;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_normal = (MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
}

void fragment() {
	vec3 pos = floor(world_pos * pixel_size + noise_seed) / pixel_size;

    float nx = fract(sin(dot(pos.yz + noise_seed, vec2(127.1, 311.7))) * 43758.5453);
    float ny = fract(sin(dot(pos.xz + noise_seed, vec2(127.1, 311.7))) * 43758.5453);
    float nz = fract(sin(dot(pos.xy + noise_seed, vec2(127.1, 311.7))) * 43758.5453);

    vec3 blend = abs(world_normal);
    blend = blend / (blend.x + blend.y + blend.z);

	float ao = COLOR.r;
    float noise = nx * blend.x + ny * blend.y + nz * blend.z;
	ALBEDO = color.rgb * (1.0 - noise_strength + noise * noise_strength) * ao;
}