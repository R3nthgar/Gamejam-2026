extends TileMapLayer
class_name Obscurer
func _ready():
	z_index=5
	if get_meta("hidden"):
		material=null
		modulate=Color(1,1,1)
