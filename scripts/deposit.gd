@tool
extends "res://scripts/container.gd"
@onready var collectibles: Node2D = %Collectibles
@onready var player: Player = %Player
const COLLECTIBLE = preload("uid://b88olwn04j8oe")

func _ready() -> void:
	super()
	var contained_num=0
	var remove_collectibles:={}
	for collectible_instance in global_handler.ingredients:
		for collectible_num in global_handler.ingredients[collectible_instance]:
			contained_num+=1
			var new_collectible=COLLECTIBLE.instantiate()
			if contained_num<=24:
				new_collectible.global_position=global_position+Vector2(lerp(-size/4,size/4,randf()),lerp(-size/4,size/4,randf()))
			else:
				new_collectible.global_position=player.bag.global_position
				if remove_collectibles.has(collectible_instance):
					remove_collectibles[collectible_instance]+=1
				else:
					remove_collectibles[collectible_instance]=1
			new_collectible.set_meta("start_inside",true)
			new_collectible.set_meta("collectible",collectible_instance)
			collectibles.add_child(new_collectible)
	for removed_collectible in remove_collectibles:
		global_handler.ingredients[removed_collectible]-=remove_collectibles[removed_collectible]
	var remove_potions=[]
	for potion_instance in global_handler.potions:
		contained_num+=1
		var potion_name=str(potion_instance[0])
		var potion_metadata=potion_instance[1]
		var new_potion=global_handler.potion_names[potion_name].instantiate()
		if contained_num<=24:
			new_potion.global_position=global_position+Vector2(lerp(-size/4,size/4,randf()),lerp(-size/4,size/4,randf()))
			instanced_potions.append(new_potion)
		else:
			new_potion.global_position=player.bag.global_position
			remove_potions.append(potion_instance)
		for meta in potion_metadata:
			new_potion.set_meta(meta,potion_metadata[meta])
		new_potion.set_meta("start_inside",true)
		collectibles.add_child(new_potion)
	for removed_potion in remove_potions:
		global_handler.potions.erase(removed_potion)
var instanced_potions=[]
func add_to_deposit(body: Node2D):
	if body is Potion:
		instanced_potions.append(body)
		var metadata:={}
		for meta in body.get_meta_list():
			metadata[meta]=body.get_meta(meta)
		global_handler.potions.append([body.get_script().get_global_name(), metadata])
	else:
		if body.get_meta("collectible") in global_handler.ingredients:
			print("Hi")
			global_handler.ingredients[body.get_meta("collectible")]+=1
		else:
			global_handler.ingredients[body.get_meta("collectible")]=1
		print("Hi ", contained.size(), global_handler.ingredients)
func _on_container_area_1_body_entered(body: Node2D) -> void:
	if body is Collectible and not body.get_meta("start_inside") and body.held:
		add_to_deposit(body)
func _on_container_area_2_body_exited(body: Node2D) -> void:
	if body is Potion:
		if global_handler.resetting:
			instanced_potions.erase(body)
		elif body.held:
			var index=instanced_potions.find(body)
			instanced_potions.remove_at(index)
			global_handler.potions.remove_at(index)
	else:
		if body.get_meta("collectible") in global_handler.ingredients and body.held and not global_handler.resetting:
			global_handler.ingredients[body.get_meta("collectible")]-=1
			print("Hi ", contained.size(), global_handler.ingredients)
