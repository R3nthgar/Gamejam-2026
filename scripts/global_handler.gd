extends Node

const COLOR_POTION = preload("uid://ci8k3jtruhyx")
const GRAVITY_POTION = preload("uid://bpwhckui1x7uj")
const SCALING_POTION = preload("uid://cw7n3rs8rqofs")
const GOLD_POTION = preload("uid://dwbuedjeyiila")
const KABOOM_POTION = preload("uid://b8s870bqq01gw")
const potion_names := {
	"color_potion": COLOR_POTION,"gravity_potion": GRAVITY_POTION,"scaling_potion": SCALING_POTION,"gold_potion": GOLD_POTION,"kaboom_potion": KABOOM_POTION
}

const recipes: Array = [[{
	"purple_grapes": 3
}, COLOR_POTION],[{
	"ever_berries": 3
}, KABOOM_POTION], [{
	"red_apple": 3
}, GRAVITY_POTION, {"gravity": 0.33}], [{
	"red_apple": 2,
	"pink_apple": 1
}, GRAVITY_POTION, {"gravity": -1, "color": lerp(Color("red"), Color(0.5,0,1), 0.33)}], [{
	"pink_apple": 3
}, SCALING_POTION, {"scale": 1.5, "color": lerp(Color("red"), Color(0.5,0,1), 0.66)}], [{
	"pink_apple": 2,
	"red_apple": 1
}, SCALING_POTION, {"scale": 0.5}], [{
	"gold_apple": 3,
}, GOLD_POTION], [{
	"gold_apple": 1,
	"red_apple": 2
}, GRAVITY_POTION, {"price": 2, "color": lerp(Color("red"), Color("gold"), 0.33)}], [{
	"gold_apple": 1,
	"pink_apple": 2
}, SCALING_POTION, {"price": 2, "color": lerp(Color(1,0.5,1), Color("gold"), 0.33)}]]

var ingredients:={}
var potions = []
var resetting=false
var destructibles:={}

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
