extends Area2D
@onready var prev_instructions=get_meta("prev_instructions")
@onready var new_instructions=get_meta("new_instructions")
@onready var all_before=get_meta("all_before")
@onready var instructions: Instructions = %Instructions
func _on_body_entered(body: Node2D) -> void:
	if (global_handler.instruction_step==prev_instructions) if not all_before else (global_handler.instruction_step<new_instructions):
		instructions.change_instructions(new_instructions)
		queue_free()
