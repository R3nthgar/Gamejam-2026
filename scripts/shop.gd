extends Control
@onready var ingredients_container: HFlowContainer = $IngredientsContainer
@onready var potions_container: HFlowContainer = $PotionsContainer
@onready var potion_icon: TextureRect = $SpeechBox/Potion
@onready var coin_count: Label = $SpeechBox/CoinCount
@onready var ingredient_1: TextureRect = $CraftingBox/FlowContainer/Ingredient1
@onready var ingredient_2: TextureRect = $CraftingBox/FlowContainer/Ingredient2
@onready var ingredient_3: TextureRect = $CraftingBox/FlowContainer/Ingredient3
const INGREDIENT_CONTROL = preload("uid://dvbhvu7p6ccca")
const POTION_CONTROL = preload("uid://25uras5vjp6a")
const FRUIT_ATLAS = preload("uid://bu0ku1xiba0s6")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_handler.resetting=false
	var orig_rand_potion=get_random_potion()
	set_recipe(orig_rand_potion)
	var rand_potion = global_handler.craft_potion(orig_rand_potion[0])
	potion_icon.set_meta("color",rand_potion.get_meta("color"))
	potion_icon.metadata=orig_rand_potion[2] if orig_rand_potion.size()>2 else {}
	potion_icon.potion_type=orig_rand_potion[1]
	coin_count.text=str(int(rand_potion.get_meta("price")))
	for ingredient in global_handler.ingredients:
		for i in global_handler.ingredients[ingredient]:
			var new_ingredient=INGREDIENT_CONTROL.instantiate()
			new_ingredient.texture.region.position.x=global_handler.locations[ingredient].x*16
			new_ingredient.texture.region.position.y=global_handler.locations[ingredient].y*16
			new_ingredient.set_meta("type",ingredient)
			if ingredients_container.get_child_count()<24:
				ingredients_container.add_child(new_ingredient)
			else:
				potions_container.add_child(new_ingredient)
	for potion in global_handler.potions:
		var new_potion=POTION_CONTROL.instantiate()
		new_potion.set_meta("color",potion[1].color)
		new_potion.metadata=potion[1]
		new_potion.potion_type=potion[0]
		new_potion.orig_potion=potion
		if potions_container.get_child_count()<24:
			potions_container.add_child(new_potion)
		else:
			ingredients_container.add_child(new_potion)
	test_for_potion_and_ingredients()

func get_random_potion():
	var potion=global_handler.recipes.pick_random()
	return potion

func test_for_potion_and_ingredients():
	for child in ingredients_container.get_children():
		if child.get_meta("color"):
			child.highlighted.visible=child.check_match(potion_icon.metadata) and potion_icon.potion_type==child.potion_type
		else:
			child.highlighted.visible=current_recipe.has(child.get_meta("type"))
	for child in potions_container.get_children():
		if child.get_meta("color"):
			child.highlighted.visible=child.check_match(potion_icon.metadata) and potion_icon.potion_type==child.potion_type
	
var current_recipe: Dictionary={
	ingredients=[],
	recipes=[]
}

func set_recipe(recipe):
	current_recipe={ingredients=[], recipes=[]}
	var temp=[0,0,0]
	var ingredients_ui=[ingredient_1,ingredient_2,ingredient_3]
	for possible_recipe in global_handler.recipes:
		if possible_recipe[1]==recipe[1] and (({} if possible_recipe.size()<3 else possible_recipe[2])==({} if recipe.size()<3 else recipe[2])):
			current_recipe.recipes.append(recipe[0])
			var i=0
			for ingredient in possible_recipe[0]:
				for t in possible_recipe[0][ingredient]:
					var fruit_atlas=FRUIT_ATLAS.duplicate()
					fruit_atlas.region=Rect2(global_handler.locations[ingredient].x*16.0,global_handler.locations[ingredient].y*16.0,16.0,16.0)
					ingredients_ui[t+i].frames.append(fruit_atlas)
					ingredients_ui[t+i].start()
					temp[t+i]+=1
				if not current_recipe.ingredients.has(ingredient):
					current_recipe.ingredients.append(ingredient)
				i+=1
func change_scene(new_scene: String):
	get_tree().change_scene_to_file(new_scene)
func _on_door_pressed() -> void:
	call_deferred("change_scene", "res://scenes/world.tscn")
