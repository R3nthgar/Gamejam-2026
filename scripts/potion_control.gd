@tool
extends TextureRect
@onready var potion_inside: TextureRect = $PotionInside
@onready var highlighted: Label = $Highlighted

var color
var metadata
var orig_potion
var potion_type
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color=get_meta("color")
	potion_inside.modulate=color
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if color!=get_meta("color"):
		color=get_meta("color")
		potion_inside.modulate=color

func check_match(orig: Dictionary):
	for meta in orig:
		if not metadata.has(meta) or metadata[meta]!=orig[meta]:
			return false
	return true
