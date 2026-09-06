shader_type canvas_item;

// Exposed parameters in the Inspector
uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float outline_thickness : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    // Get the size of an individual pixel in UV space
    vec2 size = TEXTURE_PIXEL_SIZE * outline_thickness;
    
    // Sample the alpha values of 4 neighboring pixels (Up, Down, Left, Right)
    float alpha = texture(TEXTURE, UV).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a; // Up
    alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;  // Down
    alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a; // Left
    alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;  // Right
    
    // Get the base sprite color
    vec4 sprite_color = texture(TEXTURE, UV);
    
    // If the pixel itself is transparent but surrounded by solid pixels, draw the outline
    if (sprite_color.a == 0.0 && alpha > 0.0) {
        COLOR = outline_color;
    } else {
        COLOR = sprite_color;
    }
}