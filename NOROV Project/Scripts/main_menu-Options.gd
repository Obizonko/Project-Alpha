extends Control

onready var click = $click_audio

var saved_level = -1

func _ready():
	var save_level = File.new()
	if save_level.file_exists("./save/save_level.save"):
		save_level.open("./save/save_level.save", File.READ)
		saved_level = save_level.get_line()
		var option_load = $load_game
		option_load.text += " (рів. " + saved_level + ")"
		save_level.close()

func _on_load_game_pressed():
	click.play()
	print("run game scene: ", get_tree().change_scene("res://Scenes/Levels/level_" + saved_level + ".tscn"))

func _on_new_game_pressed():
	click.play()
	print("run game scene: ", get_tree().change_scene("res://Scenes/Levels/level_1.tscn"))

func _on_settings_pressed():
	click.play()
	print("run scene settings_page: ")
	get_tree().get_nodes_in_group("settings_page")[0].visible = true
	visible = false

func _on_exit_pressed():
	click.play()
	get_tree().quit()
