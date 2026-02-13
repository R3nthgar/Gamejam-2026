extends Node

const COLOR_POTION = preload("uid://ci8k3jtruhyx")
const GRAVITY_POTION = preload("uid://bpwhckui1x7uj")
const SCALING_POTION = preload("uid://cw7n3rs8rqofs")
const GOLD_POTION = preload("uid://dwbuedjeyiila")
const potion_names := {
	"color_potion": COLOR_POTION,"gravity_potion": GRAVITY_POTION,"scaling_potion": SCALING_POTION,"gold_potion": GOLD_POTION
}

var ingredients:={}
var potions = []

var resetting=false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
