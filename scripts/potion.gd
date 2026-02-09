#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

extends "res://scripts/collectible.gd"
@onready var potion: RigidBody2D = $"."
@onready var timer: Timer = $CollectibleCollision/Timer
@onready var potion_effect: Area2D = $CollectibleCollision/PotionEffect

#Function that allows you to control what effects a potion applies. You shouldn't modify this directly unless
#you want to change something for all potions
func apply_effect(targeted, reversed: bool):
	pass

#Controls the speed needed to shatter a potion
const shatter_speed=250

#Stops potions from shattering twice.
var exploded=false

#Contains objects affected by the potion
var affected=[]

#Function that shatters potion when it collides at a greater speed than the shattering speed
func _on_body_entered(body: Node) -> void:
	#Makes fast objects colliding with a static potion also shatter it
	var dif_velocity=0
	if body.is_class("RigidBody2D") or body.is_class("CharacterBody2D"):
		dif_velocity=(body.get_good_velocity()-prev_velocity[0]).length()
	else:
		dif_velocity=prev_velocity[0].length()
	
	if(dif_velocity>=shatter_speed and not in_bag and not held and ((not body.is_held()) if body.is_class("RigidBody2D") else true) and not exploded):
		emit_particles(get_meta("color"), 1)
		exploded=true
		#Starts timer for end of potion
		timer.start()
		affected=potion_effect.get_overlapping_bodies()
		affected.erase(potion)
		apply_effect(affected, false)

#When potion ends, it calls the apply effect function but reversed
func _on_timer_timeout() -> void:
	exploded=false
	apply_effect(affected, true)
	affected=[]
