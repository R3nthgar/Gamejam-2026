@tool
extends "res://scripts/potion.gd"
class_name KaboomPotion
const EXPLOSION = preload("uid://cdu1em1a7wcpj")
func apply_effect(targeted, reversed: bool):
	if not reversed:
		play_sound(EXPLOSION,1)
		for target in targeted:
			if target is destructible:
				target.destroy(1)
