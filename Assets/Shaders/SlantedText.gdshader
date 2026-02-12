shader_type canvas_item;
uniform float shear_amount = 0.2;

void fragment() {
    // Calculate expanded bounds
    float max_expansion = abs(shear_amount) * 0.5; // Maximum horizontal shift at edges
    vec2 expanded_uv = vec2(
        (UV.x - 0.5) * (1.0 + max_expansion) + 0.5,  // Expand width
        UV.y
    );
    
    // Apply shear to expanded UVs
    vec2 uv_sheared = expanded_uv;
    uv_sheared.x += shear_amount * (uv_sheared.y - 0.5);
    
    // Edge detection and transparency
    if (uv_sheared.x < 0.0 || uv_sheared.x > 1.0 || 
        uv_sheared.y < 0.0 || uv_sheared.y > 1.0) {
        COLOR = vec4(0.0);  // Transparent outside bounds
    } else {
        COLOR = texture(TEXTURE, uv_sheared);
    }
}