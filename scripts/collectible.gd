#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

#Change collectible metadata property to change the collectible's sprite

extends RigidBody2D
class_name Collectible

@onready var collectible_image: AnimatedSprite2D = $CollectibleCollision/CollectibleImage
@onready var collectible_inside: AnimatedSprite2D = $CollectibleCollision/CollectibleImage/CollectibleInside
@onready var audio: AudioStreamPlayer2D = $CollectibleCollision/Audio
@onready var particles: GPUParticles2D = $CollectibleCollision/Particles
@onready var instructions: Instructions = get_tree().current_scene.get_node("Instructions")

const COLLECTIBLE_SPRITES = preload("uid://ccpt5fwr0bfx8")

var collectible
#Prevents bugs from incorrectly labeled animations
var allowable_collectibles=[]
#Makes max speed of objects to prevent collision glitches.
const max_velocity=500.0
#This allows the gravity to be changed with the same function as a Rigid Body,
#making it easier to change it from other nodes
var gravity=1.0
func set_gravity(new_gravity: float):
	gravity=new_gravity
	gravity_scale=new_gravity
func gravity_get():
	return gravity
#This allows you to get a more accurate velocity for collisions,
#since when impacting something, the velocity is set to zero
var prev_velocity=[Vector2(0,0),Vector2(0,0)]
func get_good_velocity():
	return prev_velocity[0]
	
#Defines variables 
var held=false
var container

var collectible_color: Color
@onready var good_scale=scale
@onready var true_scale=scale
func change_scale(new_scale: Vector2, set_good: bool = true):
	for obj in get_children():
		if obj is Node2D:
			obj.scale*=new_scale/true_scale
	mass*=((new_scale*new_scale)/(true_scale*true_scale)).x
	if set_good:
		good_scale=new_scale
	true_scale=new_scale
#Allows modifying the collectible's sprite, and tests if the animation exists to prevent bugs
func refresh_image():
	var detailed_collectible=global_handler.detailed_collectibles[collectible]
	collectible_image.animation=detailed_collectible.type
	collectible_image.position=global_handler.transforms[detailed_collectible.type].position
	collectible_image.scale=global_handler.transforms[detailed_collectible.type].scale
	collectible_inside.animation=detailed_collectible.type
	collectible_color=detailed_collectible.color if not self is Potion else get_meta("color")
	collectible_inside.modulate=collectible_color
#Ensures the sprite is up to date in the editor

#Allows objects to start without falling. Change the start static metadata property to allow this
@onready var still = get_meta("start_static")
func stop_still():
	if still:
		still=false
		gravity_scale=gravity
		if not held:
			set_collision_mask_value(1,true)
			set_collision_mask_value(5,true)
			set_collision_mask_value(3,true)
			set_collision_mask_value(2,true)

func _ready() -> void:
	allowable_collectibles=COLLECTIBLE_SPRITES.get_animation_names()
	refresh_image()
	gravity=gravity_scale
	if still:
		gravity_scale=0
		set_collision_mask_value(1,false)
		set_collision_mask_value(5,false)
		set_collision_mask_value(3,false)
		set_collision_mask_value(2,false)
		
#This lets you create a sound, with sound being a specific file (look above to the preloaded consts),
#and pitch letting you change the pitch of the sound, currently used so that when you're big,
#the jump sound is lower
func play_sound(sound: AudioStream, pitch: float = 1):
	audio.stream=sound
	audio.pitch_scale=pitch
	audio.play()


#This lets you emit particles from the collectible, with color determining the color of the particles,
#and speed controlling the speed the particles go, allowing you to make particles go in reverse
func emit_particles(color: Color, speed: float = 1):
	particles.process_material.radial_velocity_min=10*speed
	particles.process_material.radial_velocity_max=20*speed
	if speed <0:
		particles.process_material.emission_sphere_radius = 5*abs(speed)
	else:
		particles.process_material.emission_sphere_radius = 0.01
		
	particles.modulate=color
	particles.emitting=true

#Allows accessing and setting of variables for other nodes
func set_container(new_container):
	container=new_container

#This function enables you to click and drag the collectible
func _input(event):
	if held and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		held=false
		z_index=0
		set_collision_mask_value(3,true)
		set_collision_mask_value(5,true)
		if container:
			set_collision_mask_value(5,false)
			set_collision_mask_value(2,false)
			set_collision_mask_value(6,false)
			if container.get_meta("is_bag"):
				set_collision_mask_value(4,true)
				set_collision_mask_value(9,false)
			elif not container.get_meta("is_deposit"):
				set_collision_mask_value(1,true)
				set_collision_mask_value(9,false)
			else:
				set_collision_mask_value(9,true)
		else:
			set_collision_mask_value(1,true)
			set_collision_mask_value(2,true)
		gravity_scale=gravity
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		stop_still()
		gravity_scale=0
		held=true
		z_index=5
		set_meta("start_inside",false)
		set_collision_mask_value(1,false)
		if container:
			set_collision_mask_value(2,false)
		else:
			set_collision_layer_value(6,true)
		set_collision_mask_value(3,false)
		set_collision_mask_value(4,false)
		set_collision_mask_value(5,false)
		set_collision_mask_value(9,false)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	particles.rotation=rotation*-1
	if(linear_velocity.length()>max_velocity):
		linear_velocity=linear_velocity.normalized()*lerp(linear_velocity.length(),max_velocity,0.5)
	if(held):
		linear_velocity=global_position.direction_to(get_global_mouse_position())*min(max_velocity,global_position.distance_squared_to(get_global_mouse_position()))
	prev_velocity.append(linear_velocity)
	prev_velocity.remove_at(0)
	state.apply_central_force(linear_velocity)

func _on_body_entered(body: Node) -> void:
	if still and body is Collectible and body.get_collision_layer_value(6):
		stop_still()
