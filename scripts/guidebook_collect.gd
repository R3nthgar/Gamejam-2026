extends Area2D
@onready var instructions: Instructions = %Instructions
@onready var guidebook: Control = $Guidebook


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guidebook.switch(true)
	if global_handler.guidebook_collected:
		queue_free()
		print(get_node("Guidebook/SubViewportContainer/SubViewport/Recipes"))


func _on_body_entered(body: Node2D) -> void:
	body.guidebook.switch(true)
	global_handler.guidebook_collected=true
	instructions.change_temp_instructions(3)
	queue_free()
