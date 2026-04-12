shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 5.0) = 2.0;
uniform float wave_strength : hint_range(0.0, 0.05) = 0.005;
uniform float wave_frequency : hint_range(0.0, 30.0) = 12.0;

void fragment() {
    vec2 uv = UV;
    
    uv.x += cos(TIME * wave_speed + uv.y * wave_frequency) * wave_strength;
    uv.y += sin(TIME * wave_speed + uv.x * wave_frequency) * wave_strength;
    
    COLOR = texture(TEXTURE, uv);
}