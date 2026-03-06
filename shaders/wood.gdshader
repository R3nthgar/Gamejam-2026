shader_type canvas_item;
uniform sampler2D noise_texture;
uniform sampler2D normal_texture;
void fragment() {
    vec4 screen_col = texture(TEXTURE, UV);
    float noise_val = texture(noise_texture, UV).x;
    float normal_val = texture(normal_texture, UV).x;
	COLOR = vec4((screen_col.rgb + (noise_val * 0.15)  + (normal_val * 0.1))/1.25, screen_col.a);
}