extends TextureRect

var frame=0
var frames=[]
# Called when the node enters the scene tree for the first time.
func start():
	texture=frames[frame]


func _on_timer_timeout() -> void:
	frame=(frame+1)%(frames.size())
	texture=frames[frame]
