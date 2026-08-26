shader_type canvas_item;

const vec3 PRESSURE_MIN = vec3(0.0, 0.0, 1.0);
const vec3 PRESSURE_MID = vec3(0.0, 1.0, 0.0);
const vec3 PRESSURE_MAX = vec3(1.0, 0.0, 0.0);

uniform vec2[1000] pressure_points;
uniform float[1000] pressure_radii;

void fragment() {
	float weight = 0.0;
	
	for (int i = 0; i < pressure_points.length(); i++) {
		vec2 dist = (UV - pressure_points[i] / vec2(textureSize(TEXTURE, 0))) / TEXTURE_PIXEL_SIZE;
		if (length(dist) < pressure_radii[i]) {
			weight += mix(0.0, 0.2, 1.0 - length(dist) / pressure_radii[i]);
		}
	}
	
	vec3 color;
	if (weight < 0.5) color = mix(PRESSURE_MIN, PRESSURE_MID, weight);
	else color = mix(PRESSURE_MID, PRESSURE_MAX, weight);
	COLOR = vec4(color, 1.0);
}