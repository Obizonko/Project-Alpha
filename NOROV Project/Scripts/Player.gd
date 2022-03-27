extends KinematicBody2D

const MAX_SPEED = 500
const ACCELERATION = 2000
const FRICTION = 4000

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO

onready var player_sprite = $Sprite
onready var animationTree = $AnimationTree

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animationTree.set("parameters/Idle/blend_position", input_vector)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
