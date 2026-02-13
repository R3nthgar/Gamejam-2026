extends Area2D
@onready var player: CharacterBody2D = %Player

func _on_body_entered(body: Node2D) -> void:
	if not body.is_class("StaticBody2D"):
		if body == player:
			global_handler.resetting=true
			get_tree().reload_current_scene()
		else:
			body.queue_free()
