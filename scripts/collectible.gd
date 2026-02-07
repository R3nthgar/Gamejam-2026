@tool
extends RigidBody2D
@onready var collectible: RigidBody2D = $"."
@onready var collectible_image: AnimatedSprite2D = $CollectibleImage
@onready var player: CharacterBody2D = %Player

const allowable_collectibles=["purple_grapes", "apple", "apples"]
var held=false
var in_bag=false
var should_set_position=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(allowable_collectibles.has(get_meta("collectible"))):
		collectible_image.animation=get_meta("collectible")
func _process(delta: float) -> void:
	if Engine.is_editor_hint() and collectible_image.animation!=get_meta("collectible") and allowable_collectibles.has(get_meta("collectible")):
		collectible_image.animation=get_meta("collectible")
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
			gravity_scale=1
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if(held):
		linear_velocity=position.direction_to(get_global_mouse_position())*min(1000,position.distance_squared_to(get_global_mouse_position()))
	elif(should_set_position):
		position=should_set_position
		should_set_position=false

func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		gravity_scale=0
		held=true
		set_collision_mask_value(1,false)
		if in_bag or not player.bag_full():
			set_collision_mask_value(2,false)
		set_collision_mask_value(3,false)
		set_collision_mask_value(4,false)
