extends TextureProgressBar
@onready var player: CharacterBody2D = %Player
func _process(delta: float) -> void:
	if is_instance_valid(player):
		set ("value" , player.health)
