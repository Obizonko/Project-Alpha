extends Node2D

onready var music_quiet = $Additions/Music/quiet
onready var music_battle = $Additions/Music/battle
onready var animation = $Additions/Music/music_animation
onready var enemyes = $World/Enemies
onready var player = $World/Player

enum {
	START,
	IDLE,
	BATTLE,
	MOVE
}

var after_battle_time = 0
var after_battle_timer = 5

var state = START

func _ready():
	music_battle.volume_db = -80
	music_quiet.volume_db = -80
	
	var save_data = File.new()
	var dir = Directory.new()
	dir.open("./")
	dir.make_dir("save")
	save_data.open("./save/save_level.save", File.WRITE)
	save_data.store_line("1")
	save_data.close()
	
func restart_level():
	print("restart game:", get_tree().change_scene("res://Scenes/Levels/level_1.tscn"))

func _physics_process(delta):
	gates()
	
	if player.health <= 0:
		restart_level()

	match state:
		START:
			animation.play("quiet_on")
			state = IDLE

		IDLE:
			var enemy_nodes = $World/Enemies
			for enemy in enemy_nodes.get_children():
				if enemy.state == 1:
					state = BATTLE
					break
			
			if state == IDLE:
				after_battle_time += delta
				if after_battle_time > after_battle_timer:
					player_regen(delta)
					if music_quiet.volume_db == -80:
						animation.play("to_quiet")
		
		BATTLE:
			if music_battle.volume_db == -80:
				animation.play("to_battle")
			state = IDLE
			after_battle_time = 0

func gates():
	if len(enemyes.get_children()) == 0:
		var closed_gates = $World/closed_gates
		closed_gates.visible = false
		closed_gates.set_collision_layer_bit(0, false)
		closed_gates.set_collision_layer_bit(2, false)
		closed_gates.set_collision_mask_bit(0, false)
		
		var open_gates = $World/open_gates
		
		open_gates.visible = true
		open_gates.set_collision_layer_bit(0, true)
		open_gates.set_collision_layer_bit(2, true)
		open_gates.set_collision_mask_bit(0, true)
		
		var next_level_col = $next_level/CollisionShape2D
		next_level_col.disabled = false

func player_regen(delta):
	player.health += player.regeneration * delta
	player.health = min(player.health, player.max_health)

func _on_next_level_body_entered(body):
	if body.name == "Player":
		print("next level:", get_tree().change_scene("res://Scenes/Levels/level_2.tscn"))
