#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

extends CharacterBody2D
class_name Player
@onready var animated_player_sprite: AnimatedSprite2D = $AnimatedPlayerSprite
@onready var bag: Node2D = $Bag
@onready var player_camera: Camera2D = $PlayerCamera
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var particles: GPUParticles2D = $Particles
@onready var particles_2: GPUParticles2D = $Particles2
var particles_finished=true
var particles_finished_2=true
const JUMP = preload("uid://qxb77221bpq")
const COIN = preload("uid://cpqqhg52cev4j")
const EXPLOSION = preload("uid://cdu1em1a7wcpj")

#These are the constants, with SPEED determining character speed and jump velocity determining initial jump height
const SPEED = 150.0
const JUMP_VELOCITY = -350.0

#Allows air jumping if max jumps is greater than 1, or preventing jumps altogether if max jumps is 0
var max_jumps=1
var jumps=0

var falling_through=0
var health = 100.0
func hurt (damage):
	health -=damage
	if health <=0:
		global_handler.resetting=true
		get_tree().reload_current_scene()

var dead=false

#This makes it so you don't have to change the camera zoom in the code
var zoom
func _ready() -> void:
	dead=global_handler.resetting
	if dead:
		emit_particles(Color(255,0,255),2)
		emit_particles(Color(255,200,0),2)
	zoom=player_camera.zoom
	global_handler.resetting=false

#This allows the gravity to be changed with the same function as a Rigid Body,
#making it easier to change it from other nodes
var gravity=1.0
func set_gravity(new_gravity: float):
	gravity=new_gravity
	for obj in bag.get_contained():
		obj.set_gravity(gravity)
func gravity_get():
	return gravity
	
#This allows you to get a more accurate velocity for collisions,
#since when impacting something, the velocity is set to zero
var prev_velocity=[Vector2(0,0),Vector2(0,0)]
func get_good_velocity():
	return prev_velocity[0]

#This lets you emit particles from the player, with color determining the color of the particles,
#and speed controlling the speed the particles go, allowing you to make particles go in reverse
func emit_particles(color: Color, speed: float = 1, allocate: int = 0):
	var chosen_particles:=particles
	if (allocate==0 and not particles_finished) or allocate == 2:
		particles_finished_2=false
		chosen_particles=particles_2
	else:
		particles_finished=false
	chosen_particles.process_material.radial_velocity_min=25*speed
	chosen_particles.process_material.radial_velocity_max=50*speed
	if speed <0:
		chosen_particles.process_material.emission_sphere_radius = 5
	else:
		chosen_particles.process_material.emission_sphere_radius = 0.01
	chosen_particles.modulate=color
	chosen_particles.emitting=true

#This lets you create a sound, with sound being a specific file (look above to the preloaded consts),
#and pitch letting you change the pitch of the sound, currently used so that when you're big,
#the jump sound is lower
func play_sound(sound: AudioStream, pitch: float = 1):
	audio.stream=sound
	audio.pitch_scale=pitch
	audio.play()

#Gets whether the bag is full for use by other nodes
func bag_full():
	return bag.container_full()
var bagged=[]

#Allows you to set the animation of the player, with animation determining which animation to choose,
#and reset determining whether to reset if its the same animation. Reset doesn't need to be stated if its false
func set_animation(animation: String, reset: bool = false):
	if(animated_player_sprite.animation!=animation or reset):
		animated_player_sprite.animation=animation
		if not animated_player_sprite.is_playing():
			animated_player_sprite.play(animation)
		
func _physics_process(delta: float) -> void:
	if not dead:
		#Makes the zoom scale with the player's size.
		player_camera.zoom=zoom/scale
		#Makes the player's sprite flip when gravity is reversed
		up_direction=Vector2(0,-1*abs(gravity)/gravity)
		animated_player_sprite.offset.y=-2*abs(gravity)/gravity
		animated_player_sprite.flip_v=gravity<0

		#Fixes bagged variable and makes coin sound when a collectible is collected
		var contained=bag.get_contained().duplicate(true)
		if(bagged!=contained):
			if(bagged.size()<contained.size()):
				play_sound(COIN)
			bagged=contained
		#Adds the default gravity multiplied by the gravity modifier. Also allows jumping when on the roof
		if not is_on_floor():
			if jumps==0:
				jumps+=1
			velocity += get_gravity() * delta * gravity
			#Changes bagged objects' velocity to prevent visual glitching from temporarily falling out of the bag
			for obj in bag.get_contained():
				obj.linear_velocity.y+=get_gravity().y * delta * gravity
		#Resets jumps when on the ground
		else:
			jumps=0
		#Jump functionality, modified to play sounds and allow air jumping
		if Input.is_action_just_pressed("up") and jumps<max_jumps:
			jumps+=1
			play_sound(JUMP, 1/(scale.x*scale.x))
			velocity.y = JUMP_VELOCITY if gravity>=0 else -JUMP_VELOCITY
			
			#Changes bagged objects' velocity to prevent visual glitching from temporarily falling out of the bag
			for obj in bag.get_contained():
				obj.linear_velocity.y+=JUMP_VELOCITY
		
		#Allows falling through bridges
		if Input.is_action_just_pressed("down"):
			set_collision_mask_value(1,false)
			falling_through=0.01
		elif falling_through>=0.25:
			set_collision_mask_value(1,true)
			falling_through=0
		elif falling_through>0:
			falling_through+=delta
		#Movement functionality
		var direction := Input.get_axis("left", "right")
		if direction:
			set_animation("walk")
			#Flips player sprite
			animated_player_sprite.flip_h=direction==-1
			
			#Fixes bag position and ensures bagged objects move with it
			if (bag.position.x<0 and direction==-1) or (bag.position.x>0 and direction==1):
				for item in bag.get_contained():
					item.position.x+=(item.position.x-bag.global_position.x)*2
				bag.position.x*=-1
			velocity.x = direction * SPEED
			
			#Fixes visual glitching
			for obj in bag.get_contained():
				obj.linear_velocity.x=direction*SPEED
		else:
			set_animation("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		prev_velocity.append(velocity)
		prev_velocity.remove_at(0)
		move_and_slide()
	elif not animated_player_sprite.is_playing():
		dead=false


func _on_particles_finished() -> void:
	particles_finished=true


func _on_particles_2_finished() -> void:
	particles_finished_2=true


func _on_destructible_detector_body_entered(body: Node2D) -> void:
	if body is Destructible and scale.x>1.1:
		body.destroy(2)
		play_sound(EXPLOSION,1)
	elif body is Obscurer and body.get_meta("walk_remove"):
		print("Hi")
		body.visible=false
		
func _on_destructible_detector_body_exited(body: Node2D) -> void:
	if body is Obscurer and body.get_meta("walk_remove"):
		body.visible=true
