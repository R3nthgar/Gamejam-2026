#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

extends "res://scripts/potion.gd"
class_name ScalingPotion

var scale_size=1.5
var scale_arr=[]
var speed=2
func _ready() -> void:
	super()
	scale_size=get_meta("scale")
func apply_effect(targeted, reversed: bool):
	if not reversed:
		play_sound(global_handler.POWER_UP)
	if(scale_arr.size()>0):
		for entry in scale_arr:
			var targetable=entry[0]
			if is_instance_valid(targetable):
				var old_scale=entry[1]
				var new_scale=entry[2]
				targetable.change_scale(new_scale)
		scale_arr=[]
	for targetable in targeted:
		if is_instance_valid(targetable):
			if global_handler.instruction_step<18 and targetable is Player:
				instructions.change_instructions(18)
			targetable.emit_particles(get_meta("color"), -0.5 if reversed else 0.5)
			scale_arr.append([targetable, targetable.good_scale, targetable.good_scale*(1.0/scale_size if reversed else scale_size)])
			
func _physics_process(delta: float) -> void:
	if(scale_arr.size()>=0):
		for entry in scale_arr:
			var targetable=entry[0]
			if is_instance_valid(targetable):
				var old_scale=entry[1]
				var new_scale=entry[2]
				if targetable.get_collision_layer_value(6):
					targetable.change_scale(lerp(old_scale, new_scale, min(timer.wait_time-timer.time_left,1)))
				else:
					targetable.good_scale=lerp(old_scale, new_scale, min(timer.wait_time-timer.time_left,1))
		if timer.wait_time-timer.time_left>1:
			scale_arr=[]
