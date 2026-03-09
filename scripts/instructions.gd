extends RichTextLabel
class_name Instructions
var is_temp_instructions=false
func change_instructions(new_step):
	is_temp_instructions=false
	global_handler.instruction_step=new_step
	if global_handler.instruction_step<instructions.size():
		text=instructions[global_handler.instruction_step].text
		position=instructions[global_handler.instruction_step].position
	else:
		text=""
func change_temp_instructions(temp_step):
	is_temp_instructions=true
	if temp_step<temp_instructions.size():
		text=temp_instructions[temp_step].text
		position=temp_instructions[temp_step].position
	
func _ready() -> void:
	is_temp_instructions=false
	if global_handler.in_shop and global_handler.instruction_step<21:
		is_temp_instructions=true
		text=temp_instructions[0].text
		position=temp_instructions[0].position
		print(position)
	elif global_handler.instruction_step<instructions.size():
		text=instructions[global_handler.instruction_step].text
		position=instructions[global_handler.instruction_step].position
	else:
		text=""
var instructions=[{"text": "Press D or the right arrow key to move to the right", "position": Vector2(-98.0,-113.0)},{"text": "Press A or the left arrow key to move to the left", "position": Vector2(-98.0,-113.0)},{"text": "Press W or the up arrow key to jump", "position": Vector2(-98.0,-113.0)},{"text": "Drag an apple to the brown bag on your back", "position": Vector2(-137.0,-86.0)},{"text": "Drag two more apples to the brown bag on your back", "position": Vector2(-137.0,-86.0)},{"text": "Walk over to the gray cauldron on your right", "position": Vector2(-41.0,-86.0)},{"text": "Drag the apples from your bag to the gray cauldron", "position": Vector2(39.0,-70.0)},{"text": "Drag the red potion high above the cracked stone and drop it", "position": Vector2(112.0,-94.0)},{"text": "Walk on the gray bridge and press S or the down arrow", "position": Vector2(148.0,-53.0)},{"text": "Drag three purple grapes to your bag", "position": Vector2(196.0,38.0)},{"text": "Return to the surface", "position": Vector2(166.0,49.0)},{"text": "Drag the grapes from your bag to the gray cauldron", "position": Vector2(39.0,-70.0)},{"text": "Drag the purple potion high above yourself and drop it", "position": Vector2(112.0,-94.0)},{"text": "Jump over the ice wall to your right", "position": Vector2(112.0,-94.0)},{"text": "Drag three green berries to your bag", "position": Vector2(356.0,-92.0)},{"text": "Jump back over the ice wall", "position": Vector2(356.0,-115.0)},{"text": "Drag the berries from your bag to the gray cauldron", "position": Vector2(39.0,-70.0)},{"text": "Drag the green potion high above yourself and drop it", "position": Vector2(112.0,-94.0)},{"text": "Run through the cracked ice to your right", "position": Vector2(112.0,-94.0)},{"text": "Return to the apples", "position": Vector2(112.0,-94.0)},{"text": "Drag three more red apples to your bag", "position": Vector2(-45.0,-88.0)},{"text": "Walk past the brown door to your left", "position": Vector2(-204.0,-88.0)},{"text": "Click on three red apples on the shelf", "position": Vector2(359.5,72.0)},{"text": "Press D or the right arrow key", "position": Vector2(359.5,72.0)},{"text": "Press on the light gray box", "position": Vector2(359.5,8.0)},{"text": "Exit the shop by clicking on the brown door", "position": Vector2(359.5,8.0)},{"text": "You have completed the tutorial.\nTry combining different ingredients to make unique potions that let you unlock hidden areas.\nLook in the cave below the the brown bridge to find a hint book, and don't touch the lava.\nPress C to close this notification, and to skip the tutorial", "position": Vector2(-12.5,-120.0)}]
var temp_instructions=[{"text": "Click on the brown door to leave the shop", "position": Vector2(359.5,72.0)},{"text": "Click on the red exclamation point to craft a potion", "position": Vector2(39.0,-70.0)},{"text": "Press A or the left arrow key", "position": Vector2(359.5,72.0)},{"text": "Press I to open the hint book", "position": Vector2(-150.0,34.0)},{"text": "Press I to open the recipe book", "position": Vector2(-150.0,-590.0)}]
