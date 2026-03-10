shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float distortion_strength = 0.02;
uniform float time_scale = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    
    float noise = fract(sin(dot(UV + TIME * time_scale, vec2(127.1, 311.7))) * 43758.5453);
    float noise2 = fract(sin(dot(UV * 1.5 + TIME * time_scale * 0.7, vec2(311.7, 127.1))) * 43758.5453);
    
    uv.x += (noise - 0.5) * distortion_strength;
    uv.y += (noise2 - 0.5) * distortion_strength * 0.5;
    
    ALBEDO = texture(screen_texture, uv).rgb;
}