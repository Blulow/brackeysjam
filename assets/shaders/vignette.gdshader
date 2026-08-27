shader_type canvas_item;

uniform float alpha = 1.0;
uniform float inner_radius = 0.0;
uniform float outer_radius = 1.0;
uniform vec2 pos;
uniform vec2 size = vec2(1920.0, 1080.0);
uniform bool resize = false;
uniform vec4 color: source_color;

void fragment() {
	vec2 mapped_uv = UV - pos / size;
	float x = abs(mapped_uv.x) * 2.0;
	float y = abs(mapped_uv.y) * 2.0;
	if (resize) x *= size.x / size.y;
	float q = 1.0 - (1.0 - sqrt(x * x + y * y) / outer_radius) / (1.0 - inner_radius);
	COLOR = vec4(color.rgb, q * alpha);
}