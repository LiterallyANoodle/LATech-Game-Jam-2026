shader_type canvas_item;

// Pulse settings
uniform float pulse_speed : hint_range(0.0, 10.0) = 3.0;
uniform float pulse_amount : hint_range(0.0, 0.5) = 0.1;

// Wave settings
uniform float wave_frequency : hint_range(1.0, 50.0) = 12.0;
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.02;  
uniform float wave_speed : hint_range(0.0, 10.0) = 4.0;

// Color settings
uniform vec4 orb_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Bright center
uniform vec4 glow_color : source_color = vec4(0.8, 0.9, 1.0, 1.0); // Outer glow color

void fragment() {
	vec2 from_center = UV - 0.5;
	float dist = length(from_center);

	float pulse = 1.0 + (sin(TIME * pulse_speed) * pulse_amount);

	float angle = atan(from_center.y, from_center.x);
	float wave_distortion = sin(angle * wave_frequency + TIME * wave_speed) * wave_amplitude;
	
	float base_threshold = 0.35 * pulse; 
	float final_blur = smoothstep(base_threshold + wave_distortion, 0.0, dist);
	
	vec4 final_color = mix(glow_color, orb_color, final_blur * 0.7);
	final_color.a *= final_blur * (1.1 - (pulse_amount * 0.5));

	COLOR = final_color;
}