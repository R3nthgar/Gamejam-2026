extends Node
const COLOR_POTION = preload("uid://ci8k3jtruhyx")
const GRAVITY_POTION = preload("uid://bpwhckui1x7uj")
const SCALING_POTION = preload("uid://cw7n3rs8rqofs")
const GOLD_POTION = preload("uid://dwbuedjeyiila")

const recipes: Array = [[{
	"purple_grapes": 3
}, COLOR_POTION], [{
	"red_apple": 3
}, GRAVITY_POTION, {"gravity": 0.33}], [{
	"red_apple": 2,
	"green_apple": 1
}, GRAVITY_POTION, {"gravity": -1}], [{
	"green_apple": 3
}, SCALING_POTION, {"scale": 1.5}], [{
	"green_apple": 2,
	"red_apple": 1
}, SCALING_POTION, {"scale": 0.5}], [{
	"gold_apple": 3,
}, GOLD_POTION], [{
	"gold_apple": 1,
	"red_apple": 2
}, GRAVITY_POTION, {"price": 2}], [{
	"gold_apple": 1,
	"green_apple": 2
}, SCALING_POTION, {"price": 2}]]

func craft_potion(current_recipe):
	for recipe in recipes:
		if(recipe[0]==current_recipe):
			var potion=recipe[1].instantiate()
			for meta in recipe[2] if recipe.size()>=3 else {}:
				if meta=="price":
					potion.set_meta(meta, potion.get_meta(meta) * recipe[2][meta])
				else:
					potion.set_meta(meta, recipe[2][meta])
			return potion
	return false
