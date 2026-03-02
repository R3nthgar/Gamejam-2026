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
func _on_button_pressed() -> void:
	if shop:
		shop.play_sound(global_handler.TAP, 1)
		if self == shop.ingredient_control:
			highlighted.visible=false
			shop.statics[0].modulate=Color(1,1,1)
			shop.statics.erase(shop.statics[0])
			shop.set_statics()
		if self == shop.ingredient_control_2:
			highlighted.visible=false
			shop.statics[1].modulate=Color(1,1,1)
			shop.statics.erase(shop.statics[1])
			shop.set_statics()
