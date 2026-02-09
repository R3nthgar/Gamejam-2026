extends "res://scripts/container.gd"
const COLOR_POTION = preload("uid://ci8k3jtruhyx")
const GRAVITY_POTION = preload("uid://bpwhckui1x7uj")
const SCALING_POTION = preload("uid://cw7n3rs8rqofs")
@onready var collectibles: Node2D = %Collectibles

const recipes: Array = [[{
	"purple_grapes": 3
}, COLOR_POTION], [{
	"red_apple": 3
}, GRAVITY_POTION], [{
	"gold_apple": 3
}, SCALING_POTION]]
func create_potion(potion):
	for item in contained:
		item.queue_free()
	var new_child=potion.instantiate()
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
				create_potion(recipe[1])
