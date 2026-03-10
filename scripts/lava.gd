extends TextureRect

var temp=Vector2(0,0)
var direction=PI/4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#direction+=0.01
	temp+=Vector2(delta*16*0.5,0).rotated(direction)
	material.set_shader_parameter("texture_pos", temp)
