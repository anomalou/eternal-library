shader_type spatial;
render_mode unshaded;

uniform float intensity = 0.08;
uniform float speed = 2.0;
uniform float quant = 3.0;
uniform vec4 color = vec4(1, 1, 1, 1);

void vertex() {
	float t = TIME * speed;
	
	VERTEX.x += sin(t * 7.3) * intensity;
	VERTEX.y += cos(t * 5.7 + 1.0) * intensity;
	VERTEX.z += sin(t * 6.1 + 2.0) * intensity;
	
	VERTEX = floor(VERTEX * quant) / quant;
}

void fragment() {
	ALBEDO = color.rgb;
	ALPHA = color.a;
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
