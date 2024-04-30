shader_type spatial;

uniform int num_active_circles = 0;
uniform vec3 range_color : source_color;
uniform vec3 range_positions[60];
uniform float range_radiuses[60];
uniform float outlineThickness = 0.8;

float circleSDF(vec2 point, int index) {
	return distance(point, range_positions[index].xz) - range_radiuses[index];
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
		if (abs(totalSDF) < outlineThickness) {
			float emissionBlendFactor = smoothstep(outlineThickness, outlineThickness * 0.125, abs(totalSDF));
			ALBEDO = mix(vec3(0.,0.,0.), range_color.rgb, emissionBlendFactor);
			ALPHA = .3;
		} else {
			ALPHA = 0.;
		}
	} else {
		ALPHA = 0.;
	}
}
