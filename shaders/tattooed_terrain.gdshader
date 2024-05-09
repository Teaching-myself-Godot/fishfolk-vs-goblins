shader_type spatial;

uniform int num_active_circles = 0;
uniform vec3 range_color : source_color;
uniform vec3 range_positions[60];
uniform float range_radiuses[60];
uniform float max_range_radius = 2.0;
uniform sampler2D noise;

float circleSDF(vec2 point, int index) {
	return distance(point, range_positions[index].xz) - range_radiuses[index];
}


void fragment() {
	vec3 worldPosition = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	if (num_active_circles > 0) {
		vec2 position2D = worldPosition.xz;
		float totalSDF = 1e5;
		float alpha_mul = 0.5;
		for (int i = 0; i < num_active_circles; i++) {
			float currentSDF = circleSDF(position2D, i);
			totalSDF = min(totalSDF, currentSDF) / range_radiuses[i];
		}
		if (abs(totalSDF) < max_range_radius) {
			ALBEDO = range_color.rgb;
			ALPHA = (1. - totalSDF) * 0.15 * texture(noise, worldPosition.xz / 2.0 + 0.85).x;
		} else {
			ALPHA = 0.;
		}
	} else {
		ALPHA = 0.;
	}
}
