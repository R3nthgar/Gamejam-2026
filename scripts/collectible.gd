@tool
extends RigidBody2D
@onready var player: CharacterBody2D = %Player
@onready var collectible_image: AnimatedSprite2D = $CollectibleCollision/CollectibleImage
@onready var particles: GPUParticles2D = $CollectibleCollision/Particles
@onready var audio: AudioStreamPlayer2D = $CollectibleCollision/Audio
var gravity=1
func set_gravity(new_gravity: float):
	gravity=new_gravity
	gravity_scale=new_gravity
func gravity_get():
	return gravity
var prev_velocity=[Vector2(0,0),Vector2(0,0)]
func get_good_velocity():
	return prev_velocity[0]
const allowable_collectibles=["purple_grapes", "apple", "apples", "potion", "red_apple", "gold_apple", "potion2", "potion3"]
var held=false
var in_bag=false
var should_set_position=false
const max_velocity=750.0
# Called when the node enters the scene tree for the first time.
func refresh_image():
	if(allowable_collectibles.has(get_meta("collectible"))):
		collectible_image.animation=get_meta("collectible")
func _ready() -> void:
	refresh_image()
	gravity=gravity_scale
func play_sound(sound: AudioStream):
	audio.stream=sound
	audio.play()
func _process(delta: float) -> void:
	if Engine.is_editor_hint() and collectible_image.animation!=get_meta("collectible"):
		refresh_image()
func emit_particles(color: Color, size: float = 1, speed: float = 1):
	particles.process_material.radial_velocity_min=25*speed
	particles.process_material.radial_velocity_max=50*speed
	if speed <0:
		particles.process_material.emission_sphere_radius = 5
	else:
		particles.process_material.emission_sphere_radius = 0.01
		
	particles.modulate=color
	particles.scale=Vector2(size,size)
	particles.emitting=true
func go_set_position(target_position: Vector2):
	should_set_position=target_position
func is_held():
	return held
func set_in_bag(is_in_bag: bool):
	in_bag=is_in_bag
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
			held=false
			set_collision_mask_value(3,true)
			if in_bag:
				set_collision_mask_value(4,true)
				set_collision_mask_value(2,false)
			else:
				set_collision_mask_value(1,true)
				set_collision_mask_value(2,true)
			gravity_scale=gravity
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if(linear_velocity.length()>max_velocity):
		linear_velocity=linear_velocity.normalized()*lerp(linear_velocity.length(),max_velocity,0.5)
	if(held):
		linear_velocity=position.direction_to(get_global_mouse_position())*min(max_velocity,position.distance_squared_to(get_global_mouse_position()))
	elif(should_set_position):
		position=should_set_position
		should_set_position=false
	prev_velocity.append(linear_velocity)
	prev_velocity.remove_at(0)
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		gravity_scale=0
		held=true
		set_collision_mask_value(1,false)
		if in_bag or not player.bag_full():
			set_collision_mask_value(2,false)
		set_collision_mask_value(3,false)
		set_collision_mask_value(4,false)
