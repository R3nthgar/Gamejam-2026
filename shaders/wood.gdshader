shader_type canvas_item;
varying vec2 world_pos;
uniform sampler2D noise_texture;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.1;
void vertex() {
    // Calculate world position by multiplying vertex by the model's transform matrix
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0,0)).xy;
}
void fragment() {
    vec4 screen_col = texture(TEXTURE, UV);
    float noise_val = texture(noise_texture, world_pos * 0.002).x;
	COLOR = vec4(vec3(0.5,0.25,0) + (noise_val * noise_strength), screen_col.a);
}