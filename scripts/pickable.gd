extends Node2D
@onready var timer: Timer = $Timer
@onready var collectibles: Node2D = %Collectibles
const COLLECTIBLE = preload("uid://b88olwn04j8oe")
var collectible
func _ready() -> void:
	timer.wait_time=get_meta("timer")
	spawn_new()

func _process(delta: float) -> void:
	if timer.is_stopped() and not collectible.is_still():
		timer.start()

func spawn_new():
	var new_child=COLLECTIBLE.instantiate()
	new_child.set_meta("collectible", get_meta("collectible"))
	new_child.set_meta("start_static", true)
	new_child.global_position=global_position
	collectibles.add_child(new_child)
	collectible=new_child
func _on_timer_timeout() -> void:
	spawn_new()
