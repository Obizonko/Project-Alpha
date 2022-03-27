extends Control


func _on_load_game_pressed():
	pass # Replace with function body.

func _on_new_game_pressed():
	print("run scene testing_place: ", get_tree().change_scene("res://Scenes/testing_place.tscn"))

func _on_settings_pressed():
	print("run scene settings_page: ", get_tree().change_scene("res://Scenes/settings_page.tscn"))

func _on_exit_pressed():
	get_tree().quit()
