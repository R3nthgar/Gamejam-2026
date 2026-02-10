extends "res://scripts/container.gd"
const COLOR_POTION = preload("uid://ci8k3jtruhyx")
const GRAVITY_POTION = preload("uid://bpwhckui1x7uj")
const SCALING_POTION = preload("uid://cw7n3rs8rqofs")
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var collectibles: Node2D = %Collectibles
const POWER_UP = preload("uid://b3bnv0bcurjfy")
const EXPLOSION = preload("uid://cdu1em1a7wcpj")

const recipes: Array = [[{
	"purple_grapes": 3
}, COLOR_POTION], [{
	"red_apple": 3
}, GRAVITY_POTION, {"gravity": 0.166}], [{
	"red_apple": 2,
	"gold_apple": 1
}, GRAVITY_POTION, {"gravity": -0.5}], [{
	"gold_apple": 3
}, SCALING_POTION, {"scale": 1.5}], [{
	"gold_apple": 2,
	"red_apple": 1
}, SCALING_POTION, {"scale": 0.5}]]
func play_sound(sound: AudioStream, pitch: float = 1):
	audio.stream=sound
	audio.pitch_scale=pitch
	audio.play()
func create_potion(potion, metadata: Dictionary = {}):
	for item in contained:
		item.queue_free()
	var new_child=potion.instantiate()
	for meta in metadata:
		new_child.set_meta(meta, metadata[meta])
	new_child.global_position=global_position
	collectibles.add_child(new_child)
func container_effect():
	if contained.size()==3:
		var current_recipe:={}
		for collectible in contained:
			if(current_recipe.has(collectible.get_meta("collectible"))):
				current_recipe[collectible.get_meta("collectible")]+=1
			else:
				current_recipe[collectible.get_meta("collectible")]=1
		for recipe in recipes:
			if(recipe[0]==current_recipe):
				create_potion(recipe[1], {} if recipe.size()<3 else recipe[2])
				play_sound(POWER_UP,0.5)
				return
		for item in contained:
			item.queue_free()
		play_sound(EXPLOSION,0.5)
