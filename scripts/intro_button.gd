extends Button

func _on_pressed() -> void:
	if global_handler.in_shop:
		get_tree().change_scene_to_file("res://scenes/shop.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
