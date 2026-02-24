extends Control
class_name Shop
@onready var ingredients_container: HFlowContainer = $Shopfront/IngredientsContainer
@onready var potions_container: HFlowContainer = $Shopfront/PotionsContainer
@onready var potion_icon_1: Control = $Shopfront/SpeechBox/Potion
@onready var coin_count_1: Label = $Shopfront/SpeechBox/CoinCount
@onready var ingredient_control: Control = $Shopfront/CraftingBox/FlowContainer/IngredientControl
@onready var ingredient_control_2: Control = $Shopfront/CraftingBox/FlowContainer/IngredientControl2
@onready var ingredient_control_3: Control = $Shopfront/CraftingBox/FlowContainer/IngredientControl3
@onready var potion_icon_2: Control = $Back/SpeechBox/Potion
@onready var coin_count_2: Label = $Back/SpeechBox/CoinCount
@onready var coin_count: Label = $CanvasLayer/CoinCount

const COLLECTIBLE_CONTROL = preload("uid://cps0eo4ijhn16")
const POTION_CONTROL = preload("uid://bxtojffj0jj2")
const FRUIT_ATLAS = preload("uid://b41n42rnp73gh")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_count.text=str(global_handler.coins)
	global_handler.resetting=false
	if not global_handler.currently_selling:
		global_handler.currently_selling=global_handler.recipes[0]
	set_selling()
	ingredient_control.shop=self
	ingredient_control_2.shop=self
	ingredient_control_3.shop=self
	for ingredient in global_handler.ingredients:
		for i in global_handler.ingredients[ingredient]:
			var new_ingredient=COLLECTIBLE_CONTROL.instantiate()
			new_ingredient.type=ingredient
			new_ingredient.shop=self
			ingredients_container.add_child(new_ingredient)
	for potion in global_handler.potions:
		var new_potion=POTION_CONTROL.instantiate()
		new_potion.color=potion[1].color
		new_potion.shop=self
		new_potion.potion_metadata=potion[1]
		new_potion.potion_type=potion[0]
		potions_container.add_child(new_potion)
	test_for_potion_and_ingredients()
func set_selling():
	set_recipe(global_handler.currently_selling)
	var rand_potion = global_handler.craft_potion(global_handler.currently_selling[0])
	potion_icon_1.color=rand_potion.get_meta("color")
	potion_icon_1.potion_metadata=global_handler.currently_selling[2]
	potion_icon_1.potion_type=global_handler.currently_selling[1]
	potion_icon_2.color=rand_potion.get_meta("color")
	potion_icon_2.potion_metadata=global_handler.currently_selling[2]
	potion_icon_2.potion_type=global_handler.currently_selling[1]
	coin_count_1.text=str(int(rand_potion.get_meta("price")))
	coin_count_2.text=str(int(rand_potion.get_meta("price")))
	rand_potion.queue_free()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right"):
		position.x=-1152
	elif Input.is_action_just_pressed("left"):
		position.x=0
	if Input.is_action_just_pressed("refresh"):
		global_handler.currently_selling=get_random_potion()
		set_selling()

func get_random_potion():
	var sum=0
	for recipe in global_handler.recipes:
		sum+=recipe[3]
	for recipe in global_handler.recipes:
		var weight = recipe[3]
		var r = randi_range(0,sum)
		if r<weight :
			return recipe
		else:
			sum-=weight
var statics=[]
func test_for_potion_and_ingredients():
	for child in ingredients_container.get_children():
		child.highlighted.visible=temp_recipe.ingredients.has(child.type)
	for child in potions_container.get_children():
		print(child.color,potion_icon_1.color)
		child.highlighted.visible=child.color==potion_icon_1.color
var current_recipe: Dictionary={
	ingredients=[],
	recipes=[]
}
var temp_recipe: Dictionary={
	ingredients=[],
	recipes=[]
}
func set_frames():
	var ingredients_ui=[ingredient_control,ingredient_control_2,ingredient_control_3]
	for temp in ingredients_ui:
		temp.frames=[]
		temp.frame=0
	if statics.size()>=1:
		ingredients_ui[0].frames=[global_handler.detailed_collectibles[statics[0].type]]
		ingredients_ui[0].refresh()
	if statics.size()>=2:
		ingredients_ui[1].frames=[global_handler.detailed_collectibles[statics[1].type]]
		ingredients_ui[1].refresh()
	for possible_recipe in temp_recipe.recipes:
		var i=statics.size()
		for ingredient in possible_recipe:
			for t in possible_recipe[ingredient]:
				ingredients_ui[i].frames.append(global_handler.detailed_collectibles[ingredient])
				ingredients_ui[i].refresh()
				i+=1
	var temp2=[ingredient_control.frames.duplicate(),ingredient_control_2.frames.duplicate(),ingredient_control_3.frames.duplicate()]
	if statics.size()<2:
		ingredient_control_2.frames.append_array(temp2[2])
		if statics.size()<1:
			ingredient_control.frames.append_array(temp2[1])
			ingredient_control_3.frames.append_array(temp2[0])
			ingredient_control.frames.append_array(temp2[2])
			ingredient_control_2.frames.append_array(temp2[0])
		ingredient_control_3.frames.append_array(temp2[1])
func set_recipe(recipe):
	current_recipe={ingredients=[], recipes=[]}
	for possible_recipe in global_handler.recipes:
		if possible_recipe[1]==recipe[1] and possible_recipe[2]==recipe[2]:
			current_recipe.recipes.append(possible_recipe[0])
			for ingredient in possible_recipe[0]:
				if not current_recipe.ingredients.has(ingredient):
					current_recipe.ingredients.append(ingredient)
	temp_recipe=current_recipe.duplicate(true)
	set_frames()
func change_scene(new_scene: String):
	get_tree().change_scene_to_file(new_scene)
func _on_door_pressed() -> void:
	call_deferred("change_scene", "res://scenes/world.tscn")
func set_statics():
	if statics.size()==3:
		var recipe={}
		for ingredient in statics:
			global_handler.ingredients[ingredient.type]-=1
			if not ingredient.type in recipe:
				recipe[ingredient.type]=1
			else:
				recipe[ingredient.type]+=1
			ingredient.queue_free()
		statics=[]
		ingredient_control.highlighted.visible=false
		ingredient_control_2.highlighted.visible=false
		var new_potion=potion_icon_1.duplicate(13)
		new_potion.shop=self
		var true_metadata=potion_icon_1.potion_metadata.duplicate(true)
		true_metadata.color=potion_icon_1.color
		new_potion.potion_metadata=true_metadata
		new_potion.potion_type=potion_icon_1.potion_type
		new_potion.color=potion_icon_1.color
		potions_container.add_child(new_potion)
		global_handler.potions.append([potion_icon_1.potion_type, true_metadata])
	temp_recipe=current_recipe.duplicate(true)
	var removing=[]
	if statics.size()==1:
		ingredient_control.highlighted.visible=true
		ingredient_control_2.highlighted.visible=false
	elif statics.size()==2:
		ingredient_control_2.highlighted.visible=true
	for recipe in temp_recipe.recipes:
		if statics.size()==1:
			if not recipe.has(statics[0].type):
				removing.append(recipe)
		if statics.size()==2:
			if statics[0].type==statics[1].type:
				if not recipe.has(statics[0].type) or recipe[statics[0].type]<2:
					removing.append(recipe)
			else:
				if not recipe.has(statics[0].type) or not recipe.has(statics[1].type):
					removing.append(recipe)
	for recipe in removing:
		temp_recipe.recipes.erase(recipe)
	temp_recipe.ingredients=[]
	for recipe in temp_recipe.recipes:
		for i in statics:
			recipe[i.type]-=1
		for ingredient in recipe:
			if recipe[ingredient]>0:
				if not ingredient in temp_recipe.ingredients:
					temp_recipe.ingredients.append(ingredient)
	set_frames()
	test_for_potion_and_ingredients()

func _on_speech_box_pressed() -> void:
	for potion in potions_container.get_children():
		if potion.highlighted.visible:
			global_handler.coins+=int(coin_count_1.text)
			coin_count.text=str(global_handler.coins)
			var index=potions_container.get_children().find(potion)
			global_handler.potions.remove_at(index)
			potion.queue_free()
			global_handler.currently_selling=get_random_potion()
			set_selling()
			break
