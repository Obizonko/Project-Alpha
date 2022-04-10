extends KinematicBody2D

export var MAX_SPEED = 320
export var TO_MAX_TIME  = 0.2
export var TO_STOP_TIME = 0.2

var is_action_jerk = false
export var JERK_INTERVAL = {"const_time": 2, "after_prev": 0}
export var JERK_TIME : float = 0.1
export var JERK_LENGTH : float = 200

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO

onready var player_sprite = $Sprite
onready var animationTree = $AnimationTree
onready var jerk_time = $jerk_time

func _physics_process(delta):
	JERK_INTERVAL["after_prev"] += delta
	
	# show time after previous jerk and time of jerk interval
	jerk_time.text = str(stepify(JERK_INTERVAL["after_prev"], 0.1)) + "/" + str(JERK_INTERVAL["const_time"])
	
	if is_action_jerk:
		# turn off jerk action and set velocity after it
		if JERK_INTERVAL["after_prev"] >= JERK_TIME:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, MAX_SPEED / 0.1 * delta)
			if velocity.length() <= MAX_SPEED:
				is_action_jerk = false
		else:
			velocity = input_vector * JERK_LENGTH / JERK_TIME
	else:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		
		# increase / decrease player speed and set animation
		if input_vector != Vector2.ZERO:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, MAX_SPEED / TO_MAX_TIME * delta)
			animationTree.set("parameters/Idle/blend_position", input_vector)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, MAX_SPEED / TO_STOP_TIME * delta)
		
	velocity = move_and_slide(velocity)

func _input(event):
	if event.is_action_pressed("player_jerk"):
		if JERK_INTERVAL["after_prev"] > JERK_INTERVAL["const_time"]:
			is_action_jerk = true
			JERK_INTERVAL["after_prev"] = 0
