extends ColorRect
var already_paused=false
func pause():
	if not global_handler.paused:
		already_paused=Engine.time_scale==0
		global_handler.paused=true
		visible=true
		Engine.time_scale=0
func unpause():
	if global_handler.paused:
		global_handler.paused=false
		visible=false
		if not already_paused:
			Engine.time_scale=global_handler.time_scale
func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		pause()

func change_scene(new_scene: String):
	get_tree().change_scene_to_file(new_scene)

func _on_resume_pressed() -> void:
	unpause()

func _on_main_menu_pressed() -> void:
	unpause()
	global_handler.resetting=true
	call_deferred("change_scene", "res://scenes/intro_screen.tscn")
