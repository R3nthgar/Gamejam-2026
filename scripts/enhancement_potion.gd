extends "res://scripts/potion.gd"
class_name EnhancementPotion
@onready var speed=get_meta("speed")
@onready var jumps=get_meta("jumps")
func apply_effect(targeted, reversed: bool):
	for target in targeted:
		if target is Player:
			play_sound(global_handler.POWER_UP,1)
			target.emit_particles(get_meta("color"), -0.5 if reversed else 0.5)
			target.max_jumps=(target.max_jumps/jumps) if reversed else target.max_jumps*jumps
			target.SPEED=(target.SPEED/speed) if reversed else target.SPEED*speed
