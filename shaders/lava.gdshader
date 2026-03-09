shader_type canvas_item;
uniform sampler2D lava_sprite;
uniform sampler2D lava_sprite2;
uniform vec2 texture_size = vec2(1,1); // Define a float uniform for the width
uniform vec2 texture_pos = vec2(1,1); // Define a float uniform for the width
varying vec2 world_pos;
uniform vec4 color;
void ready() {
	
}
void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	// Called for every vertex the material is visible on.
}

void fragment() {
	float temp1 = 16.0;
	vec2 temp = vec2(temp1,temp1);
    vec2 grid = mod(floor((world_pos-texture_pos)*temp/vec2(24,24))/temp,1); // Size of squares in pixels
    vec2 grid2 = mod(floor((world_pos+texture_pos)*temp/vec2(24,24))/temp,1); // Size of squares in pixels
	vec4 screen_col = texture(lava_sprite, grid);
	vec4 screen_col2 = texture(lava_sprite2, grid2);
	COLOR = vec4(((screen_col.rgb/vec3(2,2,2)+screen_col2.rgb/vec3(2,2,2))/vec3(2,2,2) + color.rgb), color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
