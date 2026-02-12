#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

#This potion makes a noise when dropped. Only used for selling.
class_name gold_potion
extends "res://scripts/potion.gd"
const EXPLOSION = preload("uid://cdu1em1a7wcpj")

func apply_effect(targeted, reversed: bool):
	if not reversed:
		play_sound(EXPLOSION, 0.33)
