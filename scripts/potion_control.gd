extends "res://scripts/collectible_control.gd"

var potion_type
var potion_metadata
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type="potion"
	super()

func check_match(orig: Dictionary):
	for meta in orig:
		if not potion_metadata.has(meta) or potion_metadata[meta]!=orig[meta]:
			return false
	return true
