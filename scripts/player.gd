extends CharacterBody2D
@onready var animated_player_sprite: AnimatedSprite2D = $AnimatedPlayerSprite
@onready var bag: Node2D = $Bag
@onready var bag_alarm: RichTextLabel = $Bag/BagAlarm
@onready var bag_collision_outside: StaticBody2D = $Bag/BagCollisionOutside
@onready var player_camera: Camera2D = $PlayerCamera


const SPEED = 150.0
const JUMP_VELOCITY = -350.0
var bagged=[]
const bag_size=5
const bag_scale_mod=0.66
func bag_full():
	return bagged.size()>=bag_size

func _physics_process(delta: float) -> void:
	player_camera.zoom=Vector2(3,3)/scale
	var prev_velocity=velocity
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		for obj in bagged:
			obj.linear_velocity.y+=JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		animated_player_sprite.flip_h=direction==-1
		if (bag.position.x<0 and direction==-1) or (bag.position.x>0 and direction==1):
			for item in bagged:
				item.position.x+=(item.position.x-bag.global_position.x)*2
			bag.position.x*=-1
		velocity.x = direction * SPEED
		for obj in bagged:
			obj.linear_velocity.x=direction*SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
func setScale(object, scaleChange: float):
	object.scale*=scaleChange
func _on_bag_area_body_entered(body: Node2D) -> void:
	if(body.is_held()):
		if(bagged.size()<bag_size):
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
			if(bagged.size()<bag_size-1):
				bag_alarm.visible=false
			body.set_in_bag(false)
			for child in body.get_children():
				setScale(child, 1/bag_scale_mod)
