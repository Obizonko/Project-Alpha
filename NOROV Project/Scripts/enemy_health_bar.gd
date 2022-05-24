extends Node2D

onready var health_bar = $Health
onready var health_text = $health_info

var hb_size

onready var enemy = get_parent()

onready var MAX_HEALTH: float = enemy.health
onready var HEALTH: float = enemy.max_health

func set_text():
	var corrector = ""
	for _i in range(3 - len(str(HEALTH))):
		corrector += "  "
	health_text.text = corrector + str(int(HEALTH)) + "/" + str(MAX_HEALTH)

func update_health():
	health_bar.rect_size.x = hb_size.x * (HEALTH / MAX_HEALTH)

func _ready():
	hb_size = health_bar.rect_size
	set_text()
	update_health()
	
func _process(_delta):
	MAX_HEALTH = enemy.max_health
	HEALTH = enemy.health
	set_text()
	update_health()
