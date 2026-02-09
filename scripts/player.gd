extends CharacterBody2D
@onready var animated_player_sprite: AnimatedSprite2D = $AnimatedPlayerSprite
@onready var bag: Node2D = $Bag
@onready var bag_alarm: RichTextLabel = $Bag/BagAlarm
@onready var bag_collision_outside: StaticBody2D = $Bag/BagCollisionOutside
@onready var player_camera: Camera2D = $PlayerCamera
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var particles: GPUParticles2D = $Particles
const JUMP = preload("uid://qxb77221bpq")
const COIN = preload("uid://cpqqhg52cev4j")
var gravity=1.0

var prev_velocity=[Vector2(0,0),Vector2(0,0)]
func set_gravity(new_gravity: float):
	gravity=new_gravity
func gravity_get():
	return gravity
func get_good_velocity():
	return prev_velocity[0]
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
const SPEED = 150.0
const JUMP_VELOCITY = -350.0
var bagged=[]
const bag_size=5
const bag_scale_mod=0.66
func play_sound(sound: AudioStream, pitch: float = 1):
	audio.stream=sound
	audio.pitch_scale=pitch
	audio.play()
func bag_full():
	return bagged.size()>=bag_size
func set_animation(animation: String, reset: bool = false):
	if(animated_player_sprite.animation!=animation or reset):
		animated_player_sprite.animation=animation
func _physics_process(delta: float) -> void:
	player_camera.zoom=Vector2(3,3)/scale
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity
	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		play_sound(JUMP, 1/(scale.x*scale.x))
		velocity.y = JUMP_VELOCITY
		for obj in bagged:
			obj.linear_velocity.y+=JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		set_animation("walk")
		animated_player_sprite.flip_h=direction==-1
		if (bag.position.x<0 and direction==-1) or (bag.position.x>0 and direction==1):
			for item in bagged:
				item.position.x+=(item.position.x-bag.global_position.x)*2
			bag.position.x*=-1
		velocity.x = direction * SPEED
		for obj in bagged:
			obj.linear_velocity.x=direction*SPEED
	else:
		set_animation("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	prev_velocity.append(velocity)
	prev_velocity.remove_at(0)
	move_and_slide()
func setScale(object, scaleChange: float):
	object.scale*=scaleChange
func _on_bag_area_body_entered(body: Node2D) -> void:
	if(body.is_held() and not bagged.has(body)):
		if(bagged.size()<bag_size):
			play_sound(COIN)
			bagged.append(body)
			body.set_in_bag(true)
			for child in body.get_children():
				setScale(child, bag_scale_mod)
			if(bagged.size()>=bag_size-1):
				bag_alarm.visible=true
				if(bagged.size()>=bag_size):
					bag_alarm.modulate=Color("red")
				else:
					bag_alarm.modulate=Color("yellow")

func _on_bag_area_body_exited(body: Node2D) -> void:
	if(body.is_held() and bagged.has(body)):
		bagged.erase(body)
		if(bagged.size()<bag_size):
			if(bagged.size()<bag_size):
				if(bagged.size()<bag_size-1):
					bag_alarm.visible=false
				else:
					bag_alarm.modulate=Color("yellow")
			body.set_in_bag(false)
			for child in body.get_children():
				setScale(child, 1/bag_scale_mod)
