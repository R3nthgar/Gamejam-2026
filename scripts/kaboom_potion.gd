extends "res://scripts/potion.gd"

const EXPLOSION = preload("uid://cdu1em1a7wcpj")
func apply_effect(targeted, reversed: bool):
	if not reversed:
		play_sound(EXPLOSION,1)
		for target in targeted:
			target.queue_free()
			global_handler.destructibles[target.name]=false
