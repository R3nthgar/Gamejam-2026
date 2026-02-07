extends "res://scripts/potion.gd"

const scale_size=1.5
func apply_effect(targeted, reversed: bool):
	for targetable in targeted:
		if targetable.is_class("RigidBody2D"):
			targetable.mass*=1.0/(scale_size*scale_size) if reversed else scale_size*scale_size
			for child in targetable.get_children():
				child.scale*=1.0/scale_size if reversed else scale_size
		else:
			targetable.scale*=1.0/scale_size if reversed else scale_size
