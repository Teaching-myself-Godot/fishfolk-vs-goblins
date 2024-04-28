shader_type canvas_item;

void fragment() {
	COLOR.r = 1.;
	COLOR.g = 1.;
	COLOR.b = 0.;
	COLOR.a = COLOR.a * .8 + COLOR.a * cos(TIME * 8.) * .2;
}
