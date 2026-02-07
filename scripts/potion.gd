extends "res://scripts/collectible.gd"
@onready var potion: RigidBody2D = $"."
@onready var particles: GPUParticles2D = $CollectibleCollision/Particles
@onready var timer: Timer = $CollectibleCollision/Timer
@onready var potion_effect: Area2D = $CollectibleCollision/PotionEffect
func _ready() -> void:
	super()
	timer.wait_time=get_meta("timer_length")
func apply_effect(targeted, reversed: bool):
	pass
var prev_velocity=[Vector2(0,0),Vector2(0,0)]
const shatter_speed=200
var exploded=false
var affected=[]
func _on_body_entered(body: Node) -> void:
	var dif_velocity=0
	if body.is_class("RigidBody2D"):
		dif_velocity=(body.linear_velocity-prev_velocity[0]).length()
	elif body.is_class("CharacterBody2D"):
		dif_velocity=(body.velocity-prev_velocity[0]).length()
	else:
		dif_velocity=prev_velocity[0].length()
	if(dif_velocity>=shatter_speed and not in_bag and affected.size()==0 and not exploded):
		print("kablooey")
		timer.start()
		exploded=true
		particles.emitting=true
		affected=potion_effect.get_overlapping_bodies()
		affected.erase(potion)
		apply_effect(affected, false)
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	super(state)
	prev_velocity.append(linear_velocity)
	prev_velocity.remove_at(0)

func _on_timer_timeout() -> void:
	exploded=false
	apply_effect(affected, true)
	affected=[]
