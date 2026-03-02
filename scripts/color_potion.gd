#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

#This potion changes red apples to gold apples and vice versa
extends "res://scripts/potion.gd"
class_name ColorPotion

func apply_effect(targeted, reversed: bool):
	#Ensures that the apples don't switch colors when the effect ends. Remove this for functions that
	#reverse an effect
	if not reversed:
		play_sound(global_handler.EXPLOSION, 2)
		for targetable in targeted:
			if targetable.collectible == "ever_berries":
				targetable.collectible="purple_grapes"
				targetable.emit_particles(Color(0.5,0,1), 0.5)
				targetable.refresh_image()
			elif targetable.collectible == "purple_grapes":
				targetable.collectible="ever_berries"
				targetable.emit_particles(Color(0,1,0), 0.5)
				targetable.refresh_image()
