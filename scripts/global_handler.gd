extends Node

const COLOR_POTION = preload("uid://ci8k3jtruhyx")
const GRAVITY_POTION = preload("uid://bpwhckui1x7uj")
const SCALING_POTION = preload("uid://cw7n3rs8rqofs")
const GOLD_POTION = preload("uid://dwbuedjeyiila")
const KABOOM_POTION = preload("uid://b8s870bqq01gw")
const potion_names := {
	"color_potion": COLOR_POTION,"gravity_potion": GRAVITY_POTION,"scaling_potion": SCALING_POTION,"gold_potion": GOLD_POTION,"kaboom_potion": KABOOM_POTION
}
const collectible_colors:={"red_apple": Color(1,0,0), "pink_apple": Color(1,0.5,1), "purple_grapes": Color(0.5,0,1), "ever_berries": Color(0,1,0), "gold_apple": Color(1,0.75,0)}
const recipes: Array = [[{
	"red_apple": 3
}, KABOOM_POTION], [{
	"purple_grapes": 3
}, GRAVITY_POTION], [{
	"purple_grapes": 2,
	"ever_berries": 1
}, GRAVITY_POTION, {"gravity": -1}], [{
	"purple_grapes": 2,
	"red_apple": 1
}, GRAVITY_POTION, {"gravity": 0.75, "size": 1.25}], [{
	"ever_berries": 3
}, SCALING_POTION], [{
	"ever_berries": 2,
	"purple_grapes": 1
}, SCALING_POTION, {"scale": 0.5}], [{
	"ever_berries": 2,
	"red_apple": 1
}, SCALING_POTION, {"scale": 1.25, "size": 1.25}], [{
	"gold_apple": 3,
}, GOLD_POTION]]

var ingredients:={}
var potions = []
var resetting=false
var destructibles:={}

var mod_metas=["price", "scale"]

func craft_potion(current_recipe: Dictionary):
	var price_mod=1
	var new_recipe=current_recipe.duplicate(true)
	if new_recipe.has("gold_apple") and new_recipe["gold_apple"]!=3:
		var gold_objects = new_recipe["gold_apple"]
		new_recipe.erase("gold_apple")
		if new_recipe[new_recipe.keys()[0]]==3-gold_objects:
			new_recipe[new_recipe.keys()[0]]=3
			price_mod=1.5*gold_objects
	for recipe in recipes:
		if(recipe[0]==new_recipe):
			var potion=recipe[1].instantiate()
			for meta in recipe[2] if recipe.size()>=3 else {}:
				if meta in mod_metas:
					potion.set_meta(meta, potion.get_meta(meta) * recipe[2][meta])
				else:
					potion.set_meta(meta, recipe[2][meta])
			var new_color=Color(0,0,0)
			potion.set_meta("price", potion.get_meta("price")*price_mod)
			for ingredient in current_recipe:
				new_color+=collectible_colors[ingredient]/3*current_recipe[ingredient] if collectible_colors.has(ingredient) else Color(0,0,0)
			potion.set_meta("color", new_color)
			return potion
	return false
