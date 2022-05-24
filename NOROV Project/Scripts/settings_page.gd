extends Node2D

onready var click = $click

var sound_on_area = false

onready var sound_scroll_max = $Sound_scroll/Max
onready var sound_scroll_actual = $Sound_scroll/Actual
onready var sound_volume = $Sound_value

var volume
var save_settings

var change_volume = false

func _ready():
	save_settings = File.new()
	if save_settings.file_exists("./save/save_settings.save"):
		save_settings.open("./save/save_settings.save", File.READ)
		var saved_volume = save_settings.get_line()
		sound_scroll_actual.rect_size.x = sound_scroll_max.rect_size.x * float(saved_volume) / 100
		save_settings.close()
	update_volume()

func update_volume():
	volume = 100 - (sound_scroll_max.rect_size.x - sound_scroll_actual.rect_size.x) / (sound_scroll_max.rect_size.x) * 100
	sound_volume.text = str(int(volume)) + "%"
	
	if volume == 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -40 + 40 * volume / 100)
	
	

func _on_back_to_main_menu_pressed():
	click.play()
	print("run scene main_menu: ")
	visible = false
	get_tree().get_nodes_in_group("options")[0].visible = true


func _input(event):
	if event is InputEventMouseButton:
		print("mouse button action")
		if change_volume:
			change_volume = false
			save_settings = File.new()
			var dir = Directory.new()
			dir.open("./")
			dir.make_dir("save")
			save_settings.open("./save/save_settings.save", File.WRITE)
			save_settings.store_line(str(volume))
			save_settings.close()
			print("change off")
		elif sound_on_area:
			change_volume = true
			print("change on")
	
	if event is InputEventMouseMotion:
		if change_volume:
			var size_x = event.position.x - sound_scroll_actual.rect_position.x
			sound_scroll_actual.rect_size.x = max(min(size_x, sound_scroll_max.rect_size.x), 0) 
			update_volume()
			
func _on_Area2D_mouse_entered():
	sound_on_area = true
	print("mouse entered")


func _on_Area2D_mouse_exited():
	sound_on_area = false
	print("mouse exited")
