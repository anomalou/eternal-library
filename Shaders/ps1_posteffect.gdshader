shader_type canvas_item;

uniform float pixel_size = 2.0;
uniform float color_depth = 16.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 pixel_scale = screen_size / pixel_size;
    vec2 uv = SCREEN_UV;
    uv = floor(uv * pixel_scale) / pixel_scale; 
    vec4 color = texture(SCREEN_TEXTURE, uv);
    color.rgb = floor(color.rgb * color_depth) / color_depth;
    COLOR = color;
}