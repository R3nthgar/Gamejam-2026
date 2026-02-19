extends Control
@onready var ingredients_container: HFlowContainer = $IngredientsContainer
@onready var potions_container: HFlowContainer = $PotionsContainer
@onready var potion_icon: TextureRect = $SpeechBox/Potion
@onready var coin_count: Label = $SpeechBox/CoinCount
const INGREDIENT_CONTROL = preload("uid://dvbhvu7p6ccca")
const POTION_CONTROL = preload("uid://25uras5vjp6a")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_handler.resetting=false
	var orig_rand_potion=global_handler.recipes[0]
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
	test_for_potion()

func get_random_potion():
	var potion=global_handler.recipes.pick_random()
	return potion

func test_for_potion():
	for child in ingredients_container.get_children():
		if child.get_meta("color"):
			child.highlighted.visible=child.check_match(potion_icon.metadata) and potion_icon.potion_type==child.potion_type
	for child in potions_container.get_children():
		if child.get_meta("color"):
			child.highlighted.visible=child.check_match(potion_icon.metadata) and potion_icon.potion_type==child.potion_type


func change_scene(new_scene: String):
	get_tree().change_scene_to_file(new_scene)
func _on_door_pressed() -> void:
	call_deferred("change_scene", "res://scenes/world.tscn")
