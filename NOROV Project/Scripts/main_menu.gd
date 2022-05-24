extends Node2D

var music
var volume

func _ready():
	music = $Music/background
	volume = music.volume_db
	music.volume_db = -80

	
func _process(delta):
	if music.volume_db < volume:
		music.volume_db += 65 * delta
	else:
		music.volume_db = volume
