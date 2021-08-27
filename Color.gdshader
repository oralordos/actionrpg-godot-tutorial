shader_type canvas_item;

uniform bool active = false;
uniform vec4 color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 new_color = texture(TEXTURE, UV);
	if (active) {
		new_color.rgb = color.rgb;
		new_color.a = min(new_color.a, color.a)
	}
	COLOR = new_color;
}
