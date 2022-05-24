extends KinematicBody2D

export var MAX_SPEED = 140
export var TO_MAX_TIME  = 0.1
export var TO_STOP_TIME = 0.5

onready var playerDetectionZone = $PlayerDetectionZone
onready var player = get_tree().get_nodes_in_group("player")[0]

enum {
	IDLE,
	MOVE,
	ATTACK
}

var velocity = Vector2.ZERO
var state = IDLE
export var health = 70
var max_health = health
var target_vector = Vector2.ZERO
var anim_vector = Vector2.ZERO
var attack_timer = 0
export var attack_cooldown = 0.4
export var attack_distance = 32
export var attack_damage = 7

onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationPlayer
onready var animationState = animationTree.get("parameters/playback")
	
func _physics_process(delta):
	attack_timer += delta

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, MAX_SPEED / TO_STOP_TIME * delta)
			seek_player()
		MOVE:
			animationPlayer.playback_speed = 1
			animationTree.active = true
			move_state(delta)
			pre_attack()
		ATTACK:
			animationPlayer.playback_speed = 0.75
			attack_state()

func move_state(delta):
	target_vector.x = player.position.x - position.x
	target_vector.y = player.position.y - position.y

	anim_vector = target_vector
	target_vector = target_vector.normalized()

	animationTree.set("parameters/Run/blend_position", anim_vector)
	animationTree.set("parameters/Attack/blend_position", anim_vector)
	animationState.travel("Run")

	velocity = velocity.move_toward(target_vector * MAX_SPEED, MAX_SPEED / TO_MAX_TIME * delta)
	velocity = move_and_slide(velocity)

func attack_state():
	animationState.travel("Attack")

func seek_player():
	if playerDetectionZone.can_see_player():
		state = MOVE
		target_vector = Vector2.ZERO

func pre_attack():
	if attack_timer > attack_cooldown:
		if (player.position - position).length() < attack_distance:
			attack_timer = 0
			state = ATTACK

func attack_animation_finished():
	state = MOVE

func check_if_alive():
	if health <= 0:
		queue_free()

func _on_HurtBox_area_entered(area):
	print(area.name)
	if area.name == "SwordHitBox":
		health -= player.attack_damage
		check_if_alive()
