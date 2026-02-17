shader_type canvas_item;

uniform float blend_factor=0.75; // 0 = original, 1 = full gray

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec3 gray = vec3(0.294); // Define gray
    vec3 blended_rgb = mix(tex_color.rgb, gray, blend_factor);
    COLOR = vec4(blended_rgb, tex_color.a);
}