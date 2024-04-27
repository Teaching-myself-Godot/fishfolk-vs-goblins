shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR.b < .3) {
		COLOR.r = 1. - cos(TIME * 2.) * .25;
		COLOR.a = COLOR.a - cos(TIME * 2.) * .1;
	} else {
		COLOR.b = .35;
		COLOR.a = COLOR.a * .8 + COLOR.a * cos(TIME * 8.) * .2;
	}
}
