@tool
extends "res://scripts/container.gd"
@onready var collectibles: Node2D = %Collectibles if (true if not OS.is_debug_build() else not Engine.is_editor_hint()) else null
@onready var instructions: Instructions = %Instructions if (true if not OS.is_debug_build() else not Engine.is_editor_hint()) else null

func container_effect():
	if contained.size()==3:
		var current_recipe:={}
		for collectible in contained:
			if(current_recipe.has(collectible.collectible)):
				current_recipe[collectible.collectible]+=1
			else:
				current_recipe[collectible.collectible]=1
		if global_handler.instruction_step<7 and current_recipe=={"red_apple": 3}:
			instructions.change_instructions(7)
		elif global_handler.instruction_step<12 and current_recipe=={"purple_grapes": 3}:
			instructions.change_instructions(12)
		elif global_handler.instruction_step<17 and current_recipe=={"ever_berries": 3}:
			instructions.change_instructions(17)
		elif global_handler.instruction_step<instructions.instructions.size():
			instructions.change_instructions(global_handler.instruction_step)
		var potion=global_handler.craft_potion(current_recipe)
		if potion:
			for item in contained:
				item.queue_free()
			potion.global_position=global_position
			potion.set_meta("start_inside",true)
			contained=[]
			fix_alarm()
			collectibles.add_child(potion)
			play_sound(global_handler.POWER_UP,0.5)
		else:
			for item in contained:
				item.queue_free()
			play_sound(global_handler.EXPLOSION,1)

func _on_container_area_1_body_entered(body: PhysicsBody2D) -> void:
	if body is Collectible and not body is Potion and contained.has(body):
		if global_handler.instruction_step<17 and contained.size()>2:
			instructions.change_temp_instructions(1)
		elif instructions.is_temp_instructions and contained.size()<=2:
			instructions.change_instructions(global_handler.instruction_step)
		if global_handler.instruction_step<6 and body.collectible=="red_apple":
			instructions.change_instructions(6)
		if global_handler.instruction_step<11 and body.collectible=="purple_grapes":
			instructions.change_instructions(11)
		if global_handler.instruction_step<16 and body.collectible=="ever_berries":
			instructions.change_instructions(16)
