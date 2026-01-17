shader_type canvas_item;

uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);

void fragment() {
	vec2 centered = UV - vec2(0.5);
	centered.x *= TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;

	float dist = length(centered) * 2.0;
	float edge = smoothstep(1.0, 0.97, dist);

	if (edge <= 0.0) {
		discard;
	}

	vec4 tex_color = texture(TEXTURE, UV);

	vec4 inner = mix(background_color, tex_color, tex_color.a);
	COLOR = inner * edge;
}
