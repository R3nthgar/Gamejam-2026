extends "res://scripts/collectible.gd"
@onready var potion: RigidBody2D = $"."
@onready var particles: GPUParticles2D = $CollectibleCollision/Particles
@onready var timer: Timer = $CollectibleCollision/Timer
@onready var potion_effect: Area2D = $CollectibleCollision/PotionEffect

var prev_velocity=[0,0]
const shatter_speed=200
var exploded=false
var affected=[]
func _on_body_entered(body: Node) -> void:
	if(prev_velocity[0]>=shatter_speed and not in_bag and affected.size()==0 and not exploded):
		print("kablooey")
		timer.start()
		exploded=true
		particles.emitting=true
		affected=potion_effect.get_overlapping_bodies()
		for targetable in affected:
			if targetable.is_class("RigidBody2D"):
				for child in targetable.get_children():
					child.scale*=1.5
			else:
				targetable.scale*=1.5
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	super(state)
	prev_velocity.append(linear_velocity.length())
	prev_velocity.remove_at(0)

func _on_timer_timeout() -> void:
	exploded=false
	for targetable in affected:
			if targetable.is_class("RigidBody2D"):
				for child in targetable.get_children():
					child.scale/=1.5
			else:
				targetable.scale/=1.5
	affected=[]
