extends Control
@onready var collectible: TextureRect = $collectible
@onready var collectible_inside: TextureRect = $collectible/collectible_inside
@onready var highlighted: Label = $Highlighted

var type="red_apple"
var color: Color
var temp:={"potion": 0, "apple": 1, "grapes": 2}
var extra:={"potion":Vector2(0,1), "apple":Vector2(0,1), "grapes":Vector2(0,0)}
var shop: Shop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var detailed_collectible=global_handler.detailed_collectibles[type]
	collectible.texture.region=Rect2(16*temp[detailed_collectible.type],0,16,16)
	collectible_inside.texture.region=Rect2(16*temp[detailed_collectible.type],16,16,16)
	collectible.position=global_handler.transforms[detailed_collectible.type].position+extra[detailed_collectible.type]+Vector2(8,8)*(Vector2(1,1)-global_handler.transforms[detailed_collectible.type].scale)
	collectible.scale=global_handler.transforms[detailed_collectible.type].scale
	if not color:
		color=detailed_collectible.color
	collectible_inside.modulate=color
func _process(delta: float) -> void:
	if collectible_inside.modulate!=color:
		collectible_inside.modulate=color

func _on_button_pressed() -> void:
	if shop and highlighted.visible:
		shop.play_sound(global_handler.TAP, 1)
		if type!="potion":
			modulate=Color(0,0,0,0)
			shop.statics.append(self)
			shop.set_statics()
