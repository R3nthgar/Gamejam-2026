extends TileMapLayer
class_name Destructible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global_handler.destructibles.has(name) and global_handler.destructibles[name]==false:
		queue_free()
func destroy(level: int):
	queue_free()
	global_handler.destructibles[name]=false
