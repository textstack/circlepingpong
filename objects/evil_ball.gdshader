shader_type canvas_item;

uniform vec4 color = vec4(1.0, 0.0, 0.0, 1.0); // Default color is red
uniform float opacity : hint_range(0.0, 1.0) = 1.0; // Opacity slider, range 0 to 1

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV); // Get the texture color
    tex_color.rgb *= color.rgb; // Multiply the texture's RGB values by the red color
    tex_color.a *= opacity * color.a; // Set the alpha based on the opacity uniform and color alpha
    COLOR = tex_color; // Set the final color
}