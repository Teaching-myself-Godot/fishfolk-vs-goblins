shader_type spatial;

void fragment() {
	ALBEDO = vec3(1. - cos(TIME * 4.) * .4, 1. - cos(TIME * 4.) * .4, 0.);
	ALPHA = 9. - cos(TIME * 4.) * .4;
}