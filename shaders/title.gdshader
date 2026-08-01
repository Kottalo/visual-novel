shader_type canvas_item;

uniform float x : hint_range(0.0, 1.0) = 0.0;
uniform float size : hint_range(0.0, 1.0) = 0.06;
uniform vec3 shine_color = vec3(1.0, 0.95, 0.72);
uniform float shine_strength : hint_range(0.0, 2.0) = 0.95;
uniform float glow_strength : hint_range(0.0, 1.0) = 0.18;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	
	vec2 uv = REGION_RECT.zw * vec2(x, 0.0) + REGION_RECT.xy;
	
	float diff = abs(UV.x - uv.x);
	float band = 1.0 - smoothstep(0.0, size, diff);
	float glow = band * band;
	col.rgb = mix(col.rgb, shine_color, glow * shine_strength);
	col.rgb += glow * glow_strength;

	COLOR = col;
}
