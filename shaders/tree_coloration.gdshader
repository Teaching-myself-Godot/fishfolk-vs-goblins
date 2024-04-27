shader_type spatial;

uniform int num_active_circles = 0;
uniform vec3 range_color : source_color;
uniform vec3 range_positions[60];
uniform float range_radius = 1.;
uniform float outlineThickness = 0.8;
uniform sampler2D noise;

float circleSDF(vec2 point, int index) {
	return distance(point, range_positions[index].xz) - range_radius;
}


void fragment() {
	vec3 worldPosition = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	if (num_active_circles > 0) {
		vec2 position2D = worldPosition.xz;
		float totalSDF = 1e5;

		for (int i = 0; i < num_active_circles; i++) {
			float currentSDF = circleSDF(position2D, i);
			totalSDF = min(totalSDF, currentSDF);
		}
		if (abs(totalSDF) < range_radius) {
			ALBEDO = range_color.rgb;
			ALPHA = (1. - totalSDF / range_radius) * 0.5 * texture(noise, worldPosition.xz / 2.0 + 0.5).x;
		} else {
			ALPHA = 0.;
		}
	} else {
		ALPHA = 0.;
	}
}
