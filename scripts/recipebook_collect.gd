extends Area2D
@onready var instructions: Instructions = %Instructions
@onready var guidebook: Control = $Guidebook


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guidebook.switch(false)
	if global_handler.recipebook_collected:
		queue_free()
		print(get_node("Guidebook/SubViewportContainer/SubViewport/Recipes"))


func _on_body_entered(body: Node2D) -> void:
	body.guidebook.switch(false)
	global_handler.recipebook_collected=true
	instructions.change_temp_instructions(4)
	queue_free()
