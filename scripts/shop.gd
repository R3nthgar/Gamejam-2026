extends Control
@onready var ingredients_container: HFlowContainer = $Shopfront/IngredientsContainer
@onready var potions_container: HFlowContainer = $Shopfront/PotionsContainer
@onready var potion_icon_1: Control = $Shopfront/SpeechBox/Potion
@onready var coin_count_1: Label = $Shopfront/SpeechBox/CoinCount
@onready var ingredient_control: Control = $Shopfront/CraftingBox/FlowContainer/IngredientControl
@onready var ingredient_control_2: Control = $Shopfront/CraftingBox/FlowContainer/IngredientControl2
@onready var ingredient_control_3: Control = $Shopfront/CraftingBox/FlowContainer/IngredientControl3
@onready var potion_icon_2: Control = $Back/SpeechBox/Potion
@onready var coin_count_2: Label = $Back/SpeechBox/CoinCount
@onready var mouse_follow: Control = %MouseFollow

const COLLECTIBLE_CONTROL = preload("uid://cps0eo4ijhn16")
const POTION_CONTROL = preload("uid://bxtojffj0jj2")
const FRUIT_ATLAS = preload("uid://b41n42rnp73gh")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_handler.resetting=false
	var orig_rand_potion=get_random_potion()
	set_recipe(orig_rand_potion)
	var rand_potion = global_handler.craft_potion(orig_rand_potion[0])
	potion_icon_1.color=rand_potion.get_meta("color")
	potion_icon_1.potion_metadata=orig_rand_potion[2] if orig_rand_potion.size()>2 else {}
	potion_icon_1.potion_type=orig_rand_potion[1]
	potion_icon_2.color=rand_potion.get_meta("color")
	potion_icon_2.potion_metadata=orig_rand_potion[2] if orig_rand_potion.size()>2 else {}
	potion_icon_2.potion_type=orig_rand_potion[1]
	coin_count_1.text=str(int(rand_potion.get_meta("price")))
	coin_count_2.text=str(int(rand_potion.get_meta("price")))
	for ingredient in global_handler.ingredients:
		for i in global_handler.ingredients[ingredient]:
			var new_ingredient=COLLECTIBLE_CONTROL.instantiate()
			new_ingredient.type=ingredient
			new_ingredient.mouse_follow=mouse_follow
			ingredients_container.add_child(new_ingredient)
	for potion in global_handler.potions:
		var new_potion=POTION_CONTROL.instantiate()
		new_potion.color=potion[1].color
		new_potion.potion_metadata=potion[1]
		new_potion.potion_type=potion[0]
		new_potion.mouse_follow=mouse_follow
		potions_container.add_child(new_potion)
	test_for_potion_and_ingredients()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right"):
		position.x=-1152
	elif Input.is_action_just_pressed("left"):
		position.x=0
	mouse_follow.global_position=get_global_mouse_position()-Vector2(32,32)

func get_random_potion():
	global_handler.recipes
	var sum=0
	for recipe in global_handler.recipes:
		sum+=recipe[3]
	var selected = global_handler.recipes[0]
	for recipe in global_handler.recipes:
		var weight = recipe[3]
		var r = randi_range(0,sum)
		if r<weight :
			return recipe
		else:
			sum-=weight

func test_for_potion_and_ingredients():
	for child in ingredients_container.get_children():
		child.highlighted.visible=current_recipe.ingredients.has(child.type)
	for child in potions_container.get_children():
		child.highlighted.visible=child.check_match(potion_icon_1.potion_metadata) and potion_icon_1.potion_type==child.potion_type
var current_recipe: Dictionary={
	ingredients=[],
	recipes=[]
}

func set_recipe(recipe):
	current_recipe={ingredients=[], recipes=[]}
	var temp=[0,0,0]
	var ingredients_ui=[ingredient_control,ingredient_control_2,ingredient_control_3]
	for possible_recipe in global_handler.recipes:
		if possible_recipe[1]==recipe[1] and possible_recipe[2]==recipe[2]:
			current_recipe.recipes.append(recipe[0])
			var i=0
			for ingredient in possible_recipe[0]:
				for t in possible_recipe[0][ingredient]:
					ingredients_ui[i].frames.append(global_handler.detailed_collectibles[ingredient])
					ingredients_ui[i].refresh()
					i+=1
				if not current_recipe.ingredients.has(ingredient):
					current_recipe.ingredients.append(ingredient)
func change_scene(new_scene: String):
	get_tree().change_scene_to_file(new_scene)
func _on_door_pressed() -> void:
	call_deferred("change_scene", "res://scenes/world.tscn")
