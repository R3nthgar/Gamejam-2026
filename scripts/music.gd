extends AudioStreamPlayer
const TIME_FOR_ADVENTURE = preload("res://assets/brackeys_platformer_assets/music/time_for_adventure.mp3")
const musictracks = [TIME_FOR_ADVENTURE]
var track=0
#@onready var track_progression = musictracks.for
func trackchange(newtrack):
	if(newtrack!=track):
		stream=musictracks[newtrack]
		track=newtrack
		play(0)
