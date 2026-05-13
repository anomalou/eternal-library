shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_front;

// Параметры обводки
uniform float outline_width : hint_range(0.0, 0.2) = 0.03;
uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float outline_alpha : hint_range(0.0, 1.0) = 1.0;

// Параметры модели
uniform sampler2D albedo_texture : source_color;
uniform vec4 albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
	// Расширяем вершины вдоль нормалей
	vec3 expanded_vertex = VERTEX + NORMAL * outline_width;
	VERTEX = expanded_vertex;
}

void fragment() {
	ALBEDO = outline_color.rgb;
	ALPHA = outline_alpha;
}