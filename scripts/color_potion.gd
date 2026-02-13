#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

#This potion changes red apples to gold apples and vice versa
extends "res://scripts/potion.gd"
class_name color_potion
const EXPLOSION = preload("uid://cdu1em1a7wcpj")

func apply_effect(targeted, reversed: bool):
	#Ensures that the apples don't switch colors when the effect ends. Remove this for functions that
	#reverse an effect
	if not reversed:
		play_sound(EXPLOSION, 2)
		for targetable in targeted:
			if targetable.get_meta("collectible") == "red_apple":
				targetable.set_meta("collectible", "pink_apple")
				targetable.emit_particles(Color(1,0.5,1), 0.5)
			elif targetable.get_meta("collectible") == "pink_apple":
				targetable.set_meta("collectible", "red_apple")
				targetable.emit_particles(Color("red"), 0.5)
