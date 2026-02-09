extends "res://scripts/potion.gd"
const EXPLOSION = preload("uid://cdu1em1a7wcpj")

func apply_effect(targeted, reversed: bool):
	if not reversed:
		emit_particles(get_meta("color"), 1)
		play_sound(EXPLOSION)
		for targetable in targeted:
			if targetable.get_meta("collectible") == "red_apple":
				targetable.set_meta("collectible", "gold_apple")
				targetable.emit_particles(Color("goldenrod"), 0.5)
				targetable.refresh_image()
			elif targetable.get_meta("collectible") == "gold_apple":
				targetable.set_meta("collectible", "red_apple")
				targetable.emit_particles(Color("red"), 0.5)
				targetable.refresh_image()
