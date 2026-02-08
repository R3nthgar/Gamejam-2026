extends "res://scripts/collectible.gd"
@onready var potion: RigidBody2D = $"."
@onready var timer: Timer = $CollectibleCollision/Timer
@onready var potion_effect: Area2D = $CollectibleCollision/PotionEffect

func apply_effect(targeted, reversed: bool):
	pass
const shatter_speed=250
var exploded=false
var affected=[]
func _on_body_entered(body: Node) -> void:
	var dif_velocity=0
	if body.is_class("RigidBody2D") or body.is_class("CharacterBody2D"):
		dif_velocity=(body.get_good_velocity()-prev_velocity[0]).length()
	else:
		dif_velocity=prev_velocity[0].length()
	if(dif_velocity>=shatter_speed and not in_bag and not held and ((not body.is_held()) if body.is_class("RigidBody2D") else true) and not exploded):
		print("kablooey")
		exploded=true
		timer.start()
		emit_particles(get_meta("color"), 1)
		affected=potion_effect.get_overlapping_bodies()
		affected.erase(potion)
		apply_effect(affected, false)

func _on_timer_timeout() -> void:
	exploded=false
	apply_effect(affected, true)
	affected=[]
