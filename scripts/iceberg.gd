extends RigidBody2D


var prev_velocity=[Vector2(0,0),Vector2(0,0)]
var held=false
func get_good_velocity():
	return prev_velocity[0]
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	prev_velocity.append(linear_velocity)
	prev_velocity.remove_at(0)
func emit_particles(name,size):
	pass
