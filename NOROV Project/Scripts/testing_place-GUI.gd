extends CanvasLayer


func _on_main_menubutton_pressed():
	print("run scene main_menu: ", get_tree().change_scene("res://Scenes/main_menu.tscn"))


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_main_menubutton_pressed()
