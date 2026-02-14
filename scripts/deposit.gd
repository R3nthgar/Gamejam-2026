extends "res://scripts/container.gd"
@onready var collectibles: Node2D = %Collectibles
const COLLECTIBLE = preload("uid://b88olwn04j8oe")

func _ready() -> void:
	super()
	for potion_instance in global_handler.potions:
		var potion_name=potion_instance[0]
		var potion_metadata=potion_instance[1]
		var new_potion=global_handler.potion_names[potion_name].instantiate()
		new_potion.global_position=global_position+Vector2(lerp(-size/4,size/4,randf()),lerp(-size/4,size/4,randf()))
		for meta in potion_metadata:
			new_potion.set_meta(meta,potion_metadata[meta])
		new_potion.set_meta("start_inside",true)
		instanced_potions.append(new_potion)
		collectibles.add_child(new_potion)
	for collectible_instance in global_handler.ingredients:
		for collectible_num in global_handler.ingredients[collectible_instance]:
			var new_collectible=COLLECTIBLE.instantiate()
			new_collectible.global_position=global_position+Vector2(lerp(-size/4,size/4,randf()),lerp(-size/4,size/4,randf()))
			new_collectible.set_meta("start_inside",true)
			new_collectible.set_meta("collectible",collectible_instance)
			collectibles.add_child(new_collectible)
var instanced_potions=[]

func _on_container_area_1_body_entered(body: Node2D) -> void:
	if body is collectible and not body.get_meta("start_inside"):
		if body is potion:
			instanced_potions.append(body)
			var metadata:={}
			for meta in body.get_meta_list():
				metadata[meta]=body.get_meta(meta)
			global_handler.potions.append([body.get_script().get_global_name(), metadata])
		else:
			if body.get_meta("collectible") in global_handler.ingredients:
				global_handler.ingredients[body.get_meta("collectible")]+=1
			else:
				global_handler.ingredients[body.get_meta("collectible")]=1
func _on_container_area_2_body_exited(body: Node2D) -> void:
	if body is potion:
		if global_handler.resetting:
			instanced_potions.erase(body)
		else:
			var index=instanced_potions.find(body)
			instanced_potions.remove_at(index)
			global_handler.potions.remove_at(index)
	else:
		if body.get_meta("collectible") in global_handler.ingredients and not global_handler.resetting:
			global_handler.ingredients[body.get_meta("collectible")]-=1
