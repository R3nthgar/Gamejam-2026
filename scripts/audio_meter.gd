extends RichTextLabel

@onready var index = get_meta("index")
func _on_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(index, linear_to_db(value))
	
	
