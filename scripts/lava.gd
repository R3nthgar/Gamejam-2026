extends TextureRect

var temp=Vector2(0,0)
var direction=PI/4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("texture_size", Vector2(1,1))
	material.set_shader_parameter("color", get_meta("color"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#direction+=0.01
	temp+=Vector2(delta*16*0.2,0).rotated(direction)
	material.set_shader_parameter("texture_pos", temp)
