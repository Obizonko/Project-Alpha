extends KinematicBody2D

export var MAX_SPEED = 200
export var TO_MAX_TIME  = 0.2
export var TO_STOP_TIME = 0.1

var is_action_jerk = false
export var JERK_INTERVAL = {"const_time": 0.5, "after_prev": 0}
export var JERK_TIME : float = 0.1
export var JERK_LENGTH : float = 64

var is_action_attack = false

enum {
	MOVE, 
	JERK,
	ATTACK
}

onready var enemy_damage = {
	"enemy_1_": get_node("/root/main_node/Additions/Enemy_1").attack_damage,
	"enemy_2_": get_node("/root/main_node/Additions/Enemy_2").attack_damage,
	"enemy_3_": get_node("/root/main_node/Additions/Enemy_3").attack_damage,
	"enemy_4_": get_node("/root/main_node/Additions/Enemy_4").attack_damage
}

var state = MOVE
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var anim_vector
export var health = 100
export var max_health = 100
export var regeneration = 10
export var attack_damage = 20
var getting_damage = 0

export var attack_interval = 0.3
var prev_attack_time = 0

onready var player_sprite = $Sprite
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true


func _physics_process(delta):
	health -= getting_damage * delta
	JERK_INTERVAL["after_prev"] += delta
	prev_attack_time += delta
	
	match state:
		MOVE:
			move_state(delta)
			
		JERK:
			jerk_state(delta)
			
		ATTACK:
			move_state(delta)
			attack_state(delta)


func move_state(delta):
	var pre_vector = Vector2.ZERO
	pre_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	pre_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if state != ATTACK or (pre_vector.x == 0 and pre_vector.y == 0):
		input_vector.x = pre_vector.x
		input_vector.y = pre_vector.y
		anim_vector = input_vector
		input_vector = input_vector.normalized()
	
	
	# increase / decrease player speed and set animation
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", anim_vector)
		animationTree.set("parameters/Run/blend_position", anim_vector)
		animationTree.set("parameters/Attack/blend_position", anim_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, MAX_SPEED / TO_MAX_TIME * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, MAX_SPEED / TO_STOP_TIME * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("player_jerk"):
		if JERK_INTERVAL["after_prev"] > JERK_INTERVAL["const_time"]:
			state = JERK
			jerk_collision_off(true)
			JERK_INTERVAL["after_prev"] = 0
			
	if Input.is_action_just_pressed("player_attack"):
		if prev_attack_time > attack_interval and state != ATTACK:
			prev_attack_time = 0
			$Audio/Attack_emptines.stop()
			$Audio/Attack_emptines.play()
			state = ATTACK

func jerk_state(delta):
	# turn off jerk action and set velocity after it
	if JERK_INTERVAL["after_prev"] >= JERK_TIME:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, MAX_SPEED / 0.1 * delta)
		if velocity.length() <= MAX_SPEED:
			state = MOVE
			jerk_collision_off(false)
	else:
		velocity = input_vector * JERK_LENGTH / JERK_TIME
		
	velocity = move_and_slide(velocity)

func jerk_collision_off(value):
	var small_objects = get_tree().get_nodes_in_group("jerk_collision_off")
	for small_object in small_objects:
		small_object.set_collision_layer_bit(0, !value)
		small_object.set_collision_mask_bit(0, !value)
		small_object.set_collision_layer_bit(1, value)
		small_object.set_collision_mask_bit(1, value)

func attack_state(_delta):
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE

func _input(_event):
	pass

func _on_HurtBox_body_entered(body):
	if body.name.find("Bat", 0) != -1:
		getting_damage += 5

func _on_HurtBox_body_exited(body):
	if body.name.find("Bat", 0) != -1:
		getting_damage -= 5


func _on_HurtBox_area_entered(area):
	if area.name == "Enemy_1_SwordHitBox":
		health -= enemy_damage["enemy_1_"]
		max_health -= enemy_damage["enemy_1_"] / 2
	if area.name == "Enemy_2_SwordHitBox":
		health -= enemy_damage["enemy_2_"]
		max_health -= enemy_damage["enemy_2_"] / 2
	if area.name == "Enemy_3_SwordHitBox":
		health -= enemy_damage["enemy_3_"]
		max_health -= enemy_damage["enemy_3_"] / 2
	if area.name == "Enemy_4_SwordHitBox":
		health -= enemy_damage["enemy_4_"]
		max_health -= enemy_damage["enemy_4_"] / 2
	
