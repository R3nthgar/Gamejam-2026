@tool
extends TextureRect

var temp=Vector2(0,0)
var direction=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("texture_size", Vector2(1,1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction+=randf()/16-(1/8)
	temp+=Vector2(0.1,0).rotated(direction)
	material.set_shader_parameter("texture_size", size)
	material.set_shader_parameter("texture_pos", temp)
