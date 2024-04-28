shader_type canvas_item;
uniform bool blink = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (blink && COLOR.r < .5 && COLOR.g < .5 && COLOR.b < .5 && COLOR.a > 0.) {
		COLOR.r = 1. - sin(TIME * 4.) * .4;
		COLOR.g = 1. - sin(TIME * 4.) * .4;
		COLOR.a = COLOR.a * (1. + sin(TIME * 4.) * .4);
	}
}

