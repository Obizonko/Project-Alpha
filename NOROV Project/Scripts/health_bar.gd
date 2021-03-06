extends Node2D

onready var health_bar = $Health
onready var health_text = $health_info

var hb_size

onready var player = get_tree().get_nodes_in_group("player")[0]

onready var MAX_HEALTH: float = player.health
onready var HEALTH: float = player.max_health

func set_text():
	var corrector = ""
	for _i in range(3 - len(str(HEALTH))):
		corrector += "  "
	health_text.text = corrector + str(int(HEALTH)) + "/" + str(MAX_HEALTH)

func update_health():
	health_bar.rect_size.x = hb_size.x * (HEALTH / max(MAX_HEALTH, 0.1))

func _ready():
	hb_size = health_bar.rect_size
	set_text()
	update_health()
	
func _process(_delta):
	MAX_HEALTH = player.max_health
	HEALTH = player.health
	set_text()
	update_health()
