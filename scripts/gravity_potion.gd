extends "res://scripts/potion.gd"
const POWER_UP = preload("uid://b3bnv0bcurjfy")

const gravity_multiplier=0.5
var gravity_arr=[]
var time_passed=0
var speed=2
func apply_effect(targeted, reversed: bool):
	super(targeted,reversed)
	if not reversed:
		play_sound(POWER_UP)
	if(gravity_arr.size()>0):
		for entry in gravity_arr:
			var targetable=entry[0]
			var old_gravity=entry[1]
			var new_gravity=entry[2]
			targetable.set_gravity(new_gravity)
		gravity_arr=[]
	time_passed=0
	for targetable in targeted:
		targetable.emit_particles(get_meta("color"), 0.5, -1 if reversed else 1)
		gravity_arr.append([targetable, targetable.gravity_get(), targetable.gravity_get()*(1.0/gravity_multiplier if reversed else gravity_multiplier)])
func _physics_process(delta: float) -> void:
	if(gravity_arr.size()>=0):
		time_passed+=delta*speed
		for entry in gravity_arr:
			var targetable=entry[0]
			var old_gravity=entry[1]
			var new_gravity=entry[2]
			targetable.set_gravity(lerp(old_gravity, new_gravity, min(time_passed,1)))
		if(time_passed>=1):
			gravity_arr=[]
