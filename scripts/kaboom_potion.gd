extends "res://scripts/potion.gd"
class_name KaboomPotion
@onready var push=get_meta("push")
func apply_effect(targeted, reversed: bool):
	if not reversed:
		play_sound(global_handler.EXPLOSION,1)
		for target in targeted:
			if target is Destructible:
				target.destroy(1)
			if push!=0:
				if target is Collectible:
					target.linear_velocity+=Vector2(-100*push,0).rotated(target.position.angle_to_point(position))
				elif target is Player:
					target.velocity+=Vector2(-250*push,0).rotated(target.position.angle_to_point(position))
					target.knockover()
