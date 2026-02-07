extends "res://scripts/collectible.gd"
@onready var particles: GPUParticles2D = $Particles

var prev_velocity=[0,0]
const shatter_speed=200
func _on_body_entered(body: Node) -> void:
	if(prev_velocity[0]>=shatter_speed and not in_bag):
		print("kablooey")
		particles.emitting=true
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	super(state)
	prev_velocity.append(linear_velocity.length())
	prev_velocity.remove_at(0)
