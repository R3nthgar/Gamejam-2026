extends "res://scripts/container.gd"


func _on_container_area_1_body_entered(body: Node2D) -> void:
	if body.is_class("potion"):
		shop_handler.potions.append(body)
	else:
		if body.get_meta("collectible") in shop_handler.ingredients:
			shop_handler.ingredients[body.get_meta("collectible")]+=1
		else:
			shop_handler.ingredients[body.get_meta("collectible")]=1
func _on_container_area_2_body_exited(body: Node2D) -> void:
	if body.is_class("potion"):
		shop_handler.potions.erase(body)
