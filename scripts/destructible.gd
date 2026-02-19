extends TileMapLayer
class_name Destructible
var strength=1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	strength=get_meta("strength")
	if global_handler.destructibles.has(name) and global_handler.destructibles[name]==false:
		queue_free()
func destroy(level: int):
	if level>=strength:
		queue_free()
		global_handler.destructibles[name]=false
