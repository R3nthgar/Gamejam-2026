extends "res://scripts/potion.gd"

const scale_size=1.5
var scale_arr=[]
var time_passed=0
var speed=2
func apply_effect(targeted, reversed: bool):
	time_passed=0
	for targetable in targeted:
		if targetable.is_class("RigidBody2D"):
			targetable.mass*=1.0/(scale_size*scale_size) if reversed else scale_size*scale_size
			for child in targetable.get_children():
				#child.scale*=1.0/scale_size if reversed else scale_size
				scale_arr.append([child, child.scale, child.scale*(1.0/scale_size if reversed else scale_size)])
		else:
			#targetable.scale*=1.0/scale_size if reversed else scale_size
			scale_arr.append([targetable, targetable.scale, targetable.scale*(1.0/scale_size if reversed else scale_size)])
func _physics_process(delta: float) -> void:
	if(scale_arr.size()>=0):
		time_passed+=delta*speed
		for entry in scale_arr:
			var targetable=entry[0]
			var old_scale=entry[1]
			var new_scale=entry[2]
			targetable.scale=lerp(old_scale, new_scale, time_passed)
		if(time_passed>=1):
			scale_arr=[]
	pass
