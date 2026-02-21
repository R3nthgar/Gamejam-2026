@tool
extends Node2D
@onready var timer: Timer = $Timer
@onready var collectibles: Node2D = %Collectibles
@onready var collectible_transparent: AnimatedSprite2D = $ScaleEasy/CollectibleTransparent
@onready var collectible_transparent_inside: AnimatedSprite2D = $ScaleEasy/CollectibleTransparent/CollectibleTransparentInside
@onready var scale_easy: Node2D = $ScaleEasy
const COLLECTIBLE_SPRITES = preload("uid://ccpt5fwr0bfx8")
const COLLECTIBLE = preload("uid://b88olwn04j8oe")
var allowable_collectibles=[]
var collectible
func _ready() -> void:
	var detailed_collectible=global_handler.detailed_collectibles[get_meta("collectible")]
	collectible_transparent.animation=detailed_collectible.type
	collectible_transparent.transform=global_handler.transforms[detailed_collectible.type]
	collectible_transparent_inside.animation=detailed_collectible.type
	collectible_transparent_inside.modulate=detailed_collectible.color
	collectible_transparent.modulate=Color.WHITE
	if not Engine.is_editor_hint():
		timer.wait_time=get_meta("timer")
		spawn_new()
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if not timer.is_stopped():
			scale_easy.scale=lerp(Vector2(1,1),Vector2(0.25,0.25),timer.time_left/timer.wait_time)
			collectible_transparent.modulate=Color.from_rgba8(255,255,255,lerp(255,0,timer.time_left/timer.wait_time))
		if timer.is_stopped() and not collectible.still:
			timer.start()
	elif collectible_transparent.animation!=get_meta("collectible") and allowable_collectibles.has(get_meta("collectible")):
		collectible_transparent.animation=get_meta("collectible")
func spawn_new():
	collectible_transparent.modulate=Color.from_rgba8(255,255,255,0)
	var new_child=COLLECTIBLE.instantiate()
	new_child.set_meta("collectible", get_meta("collectible"))
	new_child.set_meta("start_static", true)
	if(rotation>PI):
		new_child.set_gravity(-1)
	new_child.global_position=global_position
	new_child.rotation=rotation
	collectibles.add_child(new_child)
	collectible=new_child
func _on_timer_timeout() -> void:
	spawn_new()
