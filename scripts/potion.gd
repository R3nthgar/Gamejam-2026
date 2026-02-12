#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

extends "res://scripts/collectible.gd"
class_name potion
@onready var timer: Timer = $CollectibleCollision/Timer
@onready var potion_effect: Area2D = $CollectibleCollision/PotionEffect
@onready var collectible_collision: CollisionShape2D = $CollectibleCollision

#Function that allows you to control what effects a potion applies. You shouldn't modify this directly unless
#you want to change something for all potions
func apply_effect(targeted, reversed: bool):
	pass

#Controls the speed needed to shatter a potion
const shatter_speed=200

#Stops potions from shattering twice.
var exploded=false

#Variable for removing the potion
var remove=false

#Contains objects affected by the potion
var affected=[]

func _ready() -> void:
	super()
	timer.wait_time=get_meta("potion_duration")

#Function that shatters potion when it collides at a greater speed than the shattering speed
func _on_body_entered(body: Node) -> void:
	#Makes fast objects colliding with a static potion also shatter it
	var dif_velocity=0
	if body.is_class("RigidBody2D") or body.is_class("CharacterBody2D"):
		dif_velocity=(body.get_good_velocity()-prev_velocity[0]).length()
	else:
		dif_velocity=prev_velocity[0].length()
	
	if(dif_velocity>=shatter_speed and not container and not held and ((not body.is_held()) if body.is_class("RigidBody2D") else true) and not exploded):
		emit_particles(get_meta("color"), 1)
		
		#Stops potion from doing anything other than the script
		exploded=true
		gravity_scale=0
		linear_velocity*=0
		collision_layer=0
		collision_mask=0
		collectible_image.visible=false
		#visible=false
		
		#Starts timer for end of potion
		timer.start()
		affected=potion_effect.get_overlapping_bodies()
		affected.erase(self)
		apply_effect(affected, false)

#When potion ends, it calls the apply effect function but reversed. It will also delete the potion after twice
#its duration has passed for efficiency reasons
func _on_timer_timeout() -> void:
	if remove:
		queue_free()
	else:
		remove=true
		timer.start()
		apply_effect(affected, true)
		affected=[]
