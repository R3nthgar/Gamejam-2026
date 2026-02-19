extends Node2D
@onready var player: Player = %Player
@onready var deposit: Node2D = $"../Deposit"
func change_scene(new_scene: String):
	get_tree().change_scene_to_file(new_scene)
func _on_door_area_body_entered(body: Node2D) -> void:
	global_handler.resetting=true
	for obj in player.bag.get_contained():
		deposit.add_to_deposit(obj)
	call_deferred("change_scene", "res://scenes/shop.tscn")
