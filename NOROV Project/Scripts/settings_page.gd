extends Node2D


func _on_back_to_main_menu_pressed():
	print("run scene main_menu: ", get_tree().change_scene("res://Scenes/main_menu.tscn"))
