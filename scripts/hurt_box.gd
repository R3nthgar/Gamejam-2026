extends Area2D
var dps=0.0
var damaging:={}
var constant=false
func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			body.hurt(dps*delta)
		elif not body.held:
			if body is Potion:
				body.explode()
			else:
				body.queue_free()
func _ready() -> void:
	dps=get_meta("damage_per_second")
