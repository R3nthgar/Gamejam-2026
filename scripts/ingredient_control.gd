extends "res://scripts/collectible_control.gd"

var frame=0
var frames=[]
var frozen=false
# Called when the node enters the scene tree for the first time.
func refresh():
	collectible.texture.region=Rect2(16*temp[frames[frame].type],0,16,16)
	collectible_inside.texture.region=Rect2(16*temp[frames[frame].type],16,16,16)
	collectible.position=global_handler.transforms[frames[frame].type].position+extra[frames[frame].type]+Vector2(8,8)*(Vector2(1,1)-global_handler.transforms[frames[frame].type].scale)
	collectible.scale=global_handler.transforms[frames[frame].type].scale
	color=frames[frame].color
func _ready() -> void:
	type="red_apple"
	super()
func _on_timer_timeout() -> void:
	if not frozen:
		frame=(frame+1)%(frames.size())
		refresh()
