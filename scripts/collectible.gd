extends RigidBody2D
@onready var collectible: RigidBody2D = $"."
@onready var mouse_position: StaticBody2D = %MousePosition

var held=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
			held=false
			set_collision_mask_value(1,true)
			gravity_scale=1
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if(held):
		linear_velocity=position.direction_to(mouse_position.position)*min(1000,max(position.distance_squared_to(mouse_position.position)+5*position.distance_squared_to(mouse_position.position),position.distance_squared_to(mouse_position.position)))


func _on_mouse_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		gravity_scale=0
		held=true
		set_collision_mask_value(1,false)
