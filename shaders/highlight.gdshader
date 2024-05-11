shader_type spatial;

uniform vec3 base_color : source_color = vec3(1.0, 1.0, 0.0);

void fragment() {
	float effect = (1.0 - cos(TIME * 4.0) * 0.4);
	ALBEDO = vec3(base_color.r * effect, base_color.g * effect,  base_color.b * effect);
	ALPHA = effect;
}