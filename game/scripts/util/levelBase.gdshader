shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_size = 1.0;

uniform bool outline_enabled = true;
uniform bool blink_enabled = false;
uniform float blink_speed = 8.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	vec2 p = TEXTURE_PIXEL_SIZE * outline_size;

	float a = 0.0;
	a = max(a, texture(TEXTURE, UV + vec2( p.x,  0.0)).a);
	a = max(a, texture(TEXTURE, UV + vec2(-p.x,  0.0)).a);
	a = max(a, texture(TEXTURE, UV + vec2( 0.0,  p.y)).a);
	a = max(a, texture(TEXTURE, UV + vec2( 0.0, -p.y)).a);
	a = max(a, texture(TEXTURE, UV + vec2( p.x,  p.y)).a);
	a = max(a, texture(TEXTURE, UV + vec2(-p.x,  p.y)).a);
	a = max(a, texture(TEXTURE, UV + vec2( p.x, -p.y)).a);
	a = max(a, texture(TEXTURE, UV + vec2(-p.x, -p.y)).a);

	vec4 final_outline = vec4(outline_color.rgb, a * outline_color.a);

	if (blink_enabled) {
		float blink = 0.5 + 0.5 * sin(TIME * blink_speed);
		final_outline.a *= blink;
	}

	if (outline_enabled && tex.a <= 0.0) {
		COLOR = final_outline;
	} else {
		COLOR = tex;
	}
}