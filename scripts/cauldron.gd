@tool
extends "res://scripts/container.gd"
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var collectibles: Node2D = %Collectibles
const POWER_UP = preload("uid://b3bnv0bcurjfy")
const EXPLOSION = preload("uid://cdu1em1a7wcpj")
const COIN = preload("uid://cpqqhg52cev4j")

func play_sound(sound: AudioStream, pitch: float = 1):
	audio.stream=sound
	audio.pitch_scale=pitch
	audio.play()
func container_effect():
	if contained.size()==3:
		var current_recipe:={}
		for collectible in contained:
			if(current_recipe.has(collectible.get_meta("collectible"))):
				current_recipe[collectible.get_meta("collectible")]+=1
			else:
				current_recipe[collectible.get_meta("collectible")]=1
		
		var potion=global_handler.craft_potion(current_recipe)
		if potion:
			for item in contained:
				item.queue_free()
			potion.global_position=global_position
			potion.set_meta("start_inside",true)
			contained=[]
			fix_alarm()
			collectibles.add_child(potion)
			play_sound(POWER_UP,0.5)
		else:
			for item in contained:
				item.queue_free()
			play_sound(EXPLOSION,1)


func _on_container_area_1_body_entered(body: PhysicsBody2D) -> void:
	if body is Collectible and not body is Potion and contained.has(body):
		body.play_sound(COIN,0.5)
