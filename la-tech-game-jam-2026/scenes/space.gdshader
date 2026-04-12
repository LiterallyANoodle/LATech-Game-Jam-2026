shader_type canvas_item;


uniform float loop_radius : hint_range(0.0, 0.5) = 0.05;
uniform float movement_speed : hint_range(0.0, 1.0) = 0.1;


uniform float woogle_strength : hint_range(0.0, 0.1) = 0.01;
uniform float woogle_freq : hint_range(0.0, 20.0) = 4.0;


uniform float layer_offset : hint_range(0.0, 0.1) = 0.02;

void fragment() {

	float t = TIME * movement_speed;
	vec2 figure_8 = vec2(sin(t), sin(t * 2.0) * 0.5) * loop_radius;
	

	vec2 woogly_uv = UV;
	woogly_uv.x += sin(TIME * 0.5 + UV.y * woogle_freq) * woogle_strength;
	woogly_uv.y += cos(TIME * 0.4 + UV.x * woogle_freq) * woogle_strength;
	

	vec4 col1 = texture(TEXTURE, woogly_uv + figure_8);
	

	vec2 figure_8_late = vec2(sin(t - layer_offset), sin((t - layer_offset) * 2.0) * 0.5) * loop_radius;
	vec4 col2 = texture(TEXTURE, woogly_uv + figure_8_late);
	

	vec2 figure_8_latest = vec2(sin(t - layer_offset * 2.0), sin((t - layer_offset * 2.0) * 2.0) * 0.5) * loop_radius;
	vec4 col3 = texture(TEXTURE, woogly_uv + figure_8_latest);
	

	vec4 final_color = col1;
	final_color = mix(final_color, col2, 0.5); 
	final_color = mix(final_color, col3, 0.3); 
	
	COLOR = final_color;
}