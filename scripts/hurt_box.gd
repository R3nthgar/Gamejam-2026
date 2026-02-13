extends Area2D
func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is player:
			body.hurt(delta*20)
		elif body is collectible and not body.held:
			if body is potion:
				body.explode()
			else:
				body.queue_free()
