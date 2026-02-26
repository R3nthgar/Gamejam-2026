extends TileMapLayer
class_name Destructible
@onready var instructions: Instructions = %Instructions
var strength=1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	strength=get_meta("strength")
	if global_handler.destructibles.has(name) and global_handler.destructibles[name]==false:
		queue_free()
func destroy(level: int):
	if level>=strength:
		if strength==1 and global_handler.instruction_step<8:
			instructions.change_instructions(8)
		if strength==2 and global_handler.instruction_step<19:
			instructions.change_instructions(19)
		queue_free()
		global_handler.destructibles[name]=false
