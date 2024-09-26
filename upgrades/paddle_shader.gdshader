shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float glow_strength : hint_range(0.0, 1.0) = 0.5;
uniform float glow_radius : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    
    // Calculate distance from the edge of the paddle
    float distance_from_edge = min(min(UV.x, 1.0 - UV.x), min(UV.y, 1.0 - UV.y));
    
    // Create a smooth glow effect
    float glow_factor = smoothstep(glow_radius, 0.0, distance_from_edge);
    
    // Mix the original color with the glow color
    vec4 final_color = mix(original_color, glow_color, glow_factor * glow_strength);
    
    COLOR = final_color;
}










