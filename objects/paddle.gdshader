shader_type canvas_item;

uniform vec4 glow_color = vec4(1.0, 1.0, 0.0, 1.0); // Default yellowish glow
uniform float intensity = 0.0; // Glow intensity
uniform float opacity = 1.0; // Glow opacity

void fragment() {
    // Get the texture color of the paddle
    vec4 tex_color = texture(TEXTURE, UV);

    // Add the glow to the texture color
    vec4 glow = glow_color * intensity;

    // Blend the glow with the paddle's original texture color
    COLOR = mix(tex_color, glow, opacity);
}
