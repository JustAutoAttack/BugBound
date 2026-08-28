shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, unshaded;

/// The base color tint of the bubble material (including its alpha channel).
uniform vec4 bubble_color : source_color = vec4(0.7, 0.9, 1.0, 1.0);

/// Master opacity scale for the entire bubble (modulates both the core and rim transparency).
uniform float overall_opacity : hint_range(0.0, 1.0) = 0.5;

/// Controls the thickness and falloff curve of the outer border ring.
uniform float rim_power : hint_range(0.1, 5.0) = 1.5;

/// The base opacity of the center of the sphere (lower values make the core more transparent).
uniform float core_opacity : hint_range(0.0, 1.0) = 0.05;

/// Multiplier for the brightness and alpha intensity of the outer rim border.
uniform float rim_intensity : hint_range(0.0, 5.0) = 2.0;

void fragment() {
    // Calculate Fresnel term based on the surface normal and view direction
    float fresnel = dot(normalize(NORMAL), normalize(VIEW));
    
    // Invert it so the edges (rim) approach 1.0 and the center approaches 0.0
    fresnel = clamp(1.0 - fresnel, 0.0, 1.0);
    
    // Apply power curve to control the thickness of the border ring
    float rim = pow(fresnel, rim_power) * rim_intensity;
    
    // Combine the faint core opacity with the outer rim border
    float final_alpha = clamp(core_opacity + rim, 0.0, 1.0);
    
    // Output color and calculated opacity modulated by overall opacity and color alpha
    ALBEDO = bubble_color.rgb;
    ALPHA = final_alpha * bubble_color.a * overall_opacity;
}