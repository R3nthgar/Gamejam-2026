#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

extends "res://scripts/potion.gd"
class_name scaling_potion
const POWER_UP = preload("uid://b3bnv0bcurjfy")

var scale_size=1.5
var scale_arr=[]
var time_passed=0
var speed=2
func _ready() -> void:
	super()
	scale_size=get_meta("scale")
func apply_effect(targeted, reversed: bool):
	if not reversed:
		play_sound(POWER_UP)
	if(scale_arr.size()>0):
		for entry in scale_arr:
			var targetable=entry[0]
			if is_instance_valid(targetable):
				var old_scale=entry[1]
				var new_scale=entry[2]
				targetable.scale=new_scale
		scale_arr=[]
	time_passed=0
	for targetable in targeted:
		if is_instance_valid(targetable):
			targetable.emit_particles(get_meta("color"), -0.5 if reversed else 0.5)
			if targetable.is_class("RigidBody2D"):
				targetable.mass*=1.0/(scale_size*scale_size) if reversed else scale_size*scale_size
				for child in targetable.get_children():
					scale_arr.append([child, child.scale, child.scale*(1.0/scale_size if reversed else scale_size)])
			else:
				scale_arr.append([targetable, targetable.scale, targetable.scale*(1.0/scale_size if reversed else scale_size)])
func _physics_process(delta: float) -> void:
	if(scale_arr.size()>=0):
		time_passed+=delta*speed
		for entry in scale_arr:
			var targetable=entry[0]
			if is_instance_valid(targetable):
				var old_scale=entry[1]
				var new_scale=entry[2]
				targetable.scale=lerp(old_scale, new_scale, min(time_passed,1))
		if(time_passed>=1):
			scale_arr=[]
