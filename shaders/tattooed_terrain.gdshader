shader_type spatial;

uniform int num_active_circles = 0;
uniform vec3 range_color : source_color;
uniform vec3 range_positions[60];
uniform float range_radiuses[60];
uniform float fades[60];

void fragment() {
	vec3 worldPosition = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	if (num_active_circles > 0) {
		vec2 position2D = worldPosition.xz;
		float alpha_hint = 0.0;
		for (int i = 0; i < num_active_circles; i++) {
			float delta = distance(position2D, range_positions[i].xz);
			if (delta < range_radiuses[i]) {
				alpha_hint = max(alpha_hint, ((range_radiuses[i] - delta) / range_radiuses[i]) * (1.0 - fades[i]));
			}
		}

		if (alpha_hint > 0.0) {
			ALBEDO = range_color.rgb;
			ALPHA = alpha_hint;
		} else {
			ALPHA = 0.;
		}
	} else {
		ALPHA = 0.;
	}
}
