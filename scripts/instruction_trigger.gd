extends Area2D
var prev_instructions
var new_instructions
var all_before
@onready var instructions: Instructions = %Instructions
func _ready() -> void:
	prev_instructions=get_meta("prev_instructions")
	new_instructions=get_meta("new_instructions")
	all_before=get_meta("all_before")
	if global_handler.instruction_step>=new_instructions:
		queue_free()
func _on_body_entered(body: Node2D) -> void:
	if (global_handler.instruction_step==prev_instructions) if not all_before else (global_handler.instruction_step<new_instructions):
		instructions.change_instructions(new_instructions)
		queue_free()
