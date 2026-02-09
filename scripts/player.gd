#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

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

#These are the constants, with SPEED determining character speed, jump velocity determining initial jump height,
#bag size determining how many objects can fit in the bag, and bag scale mod determining how much smaller the
#objects get when entering the bag
const SPEED = 150.0
const JUMP_VELOCITY = -350.0
const bag_size=5
const bag_scale_mod=0.66

#Allows air jumping if max jumps is greater than 1, or preventing jumps altogether if max jumps is 0
var max_jumps=1
var jumps=0

#This array tracks which objects are in the bag
var bagged=[]

#This makes it so you don't have to change the camera zoom in the code
var zoom
func _ready() -> void:
	zoom=player_camera.zoom

#This allows the gravity to be changed with the same function as a Rigid Body,
#making it easier to change it from other nodes
var gravity=1.0
func set_gravity(new_gravity: float):
	gravity=new_gravity
func gravity_get():
	return gravity
	
#This allows you to get a more accurate velocity for collisions,
#since when impacting something, the velocity is set to zero
var prev_velocity=[Vector2(0,0),Vector2(0,0)]
func get_good_velocity():
	return prev_velocity[0]
	
#This lets you emit particles from the player, with color determining the color of the particles,
#and speed controlling the speed the particles go, allowing you to make particles go in reverse
func emit_particles(color: Color, speed: float = 1):
	particles.process_material.radial_velocity_min=25*speed
	particles.process_material.radial_velocity_max=50*speed
	if speed <0:
		particles.process_material.emission_sphere_radius = 5
	else:
		particles.process_material.emission_sphere_radius = 0.01
	particles.modulate=color
	particles.emitting=true

#This lets you create a sound, with sound being a specific file (look above to the preloaded consts),
#and pitch letting you change the pitch of the sound, currently used so that when you're big,
#the jump sound is lower
func play_sound(sound: AudioStream, pitch: float = 1):
	audio.stream=sound
	audio.pitch_scale=pitch
	audio.play()

#Gets whether the bag is full for use by other nodes
func bag_full():
	return bagged.size()>=bag_size
	
#Allows you to set the animation of the player, with animation determining which animation to choose,
#and reset determining whether to reset if its the same animation. Reset doesn't need to be stated if its false
func set_animation(animation: String, reset: bool = false):
	if(animated_player_sprite.animation!=animation or reset):
		animated_player_sprite.animation=animation

func _physics_process(delta: float) -> void:
	#Makes the zoom scale with the player's size.
	player_camera.zoom=zoom/scale
	
	#Adds the default gravity multiplied by the gravity modifier. Also allows jumping when on the roof
	if ((not is_on_ceiling()) if gravity<0 else (not is_on_floor())):
		velocity += get_gravity() * delta * gravity
	#Resets jumps when on the ground
	else:
		jumps=0

	#Jump functionality, modified to play sounds and allow air jumping
	if Input.is_action_just_pressed("up") and jumps<max_jumps:
		jumps+=1
		play_sound(JUMP, 1/(scale.x*scale.x))
		velocity.y = JUMP_VELOCITY if gravity>=0 else -JUMP_VELOCITY
		
		#Changes bagged objects' velocity to prevent visual glitching from temporarily falling out of the bag
		for obj in bagged:
			obj.linear_velocity.y+=JUMP_VELOCITY
	
	#Movement functionality
	var direction := Input.get_axis("left", "right")
	if direction:
		set_animation("walk")
		#Flips player sprite
		animated_player_sprite.flip_h=direction==-1
		
		#Fixes bag position and ensures bagged objects move with it
		if (bag.position.x<0 and direction==-1) or (bag.position.x>0 and direction==1):
			for item in bagged:
				item.position.x+=(item.position.x-bag.global_position.x)*2
			bag.position.x*=-1
		velocity.x = direction * SPEED
		
		#Fixes visual glitching
		for obj in bagged:
			obj.linear_velocity.x=direction*SPEED
	else:
		set_animation("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	prev_velocity.append(velocity)
	prev_velocity.remove_at(0)
	move_and_slide()

#Handles objects entering the bag
func _on_bag_area_body_entered(body: Node2D) -> void:
	#Prevents objects from entering via glitches
	if body.is_held() and not bagged.has(body) and bagged.size()<bag_size:
		play_sound(COIN)
		bagged.append(body)
		body.set_in_bag(true)

		#Changes size of object
		for child in body.get_children():
			child.scale*=bag_scale_mod

		#Makes exclamation mark appear when bag is full or close to full
		if(bagged.size()>=bag_size-1):
			bag_alarm.visible=true
			if(bagged.size()>=bag_size):
				bag_alarm.modulate=Color("red")
				bag_collision_outside.set_collision_layer_value(2,true)
			else:
				bag_alarm.modulate=Color("yellow")

func _on_bag_area_body_exited(body: Node2D) -> void:
	#Prevents objects from exiting via glitches
	if(body.is_held() and bagged.has(body)):
		#Removes object from bag
		bagged.erase(body)

		#Makes exclamation mark disappear when bag isn't close to full, and changes exclamation mark color
		if(bagged.size()<bag_size):
			bag_collision_outside.set_collision_layer_value(2,false)
			if(bagged.size()<bag_size-1):
				bag_alarm.visible=false
			else:
				bag_alarm.modulate=Color("yellow")
		body.set_in_bag(false)
		
		#Changes size of object
		for child in body.get_children():
			child.scale*=bag_scale_mod
