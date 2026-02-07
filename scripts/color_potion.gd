extends "res://scripts/potion.gd"

func apply_effect(targeted, reversed: bool):
	if not reversed:
		for targetable in targeted:
			if targetable.get_meta("collectible") == "red_apple":
				targetable.set_meta("collectible", "gold_apple")
				targetable.emit_particles(Color("goldenrod"), 0.5)
				targetable.refresh_image()
			elif targetable.get_meta("collectible") == "gold_apple":
				targetable.set_meta("collectible", "red_apple")
				targetable.emit_particles(Color("red"), 0.5)
				targetable.refresh_image()
