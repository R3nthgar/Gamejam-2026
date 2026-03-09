extends "res://scripts/collectible_control.gd"

var potion_type
var potion_metadata
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type="potion"
	super()

func _on_button_pressed() -> void:
	if shop:
		shop.sell_potion(self)
