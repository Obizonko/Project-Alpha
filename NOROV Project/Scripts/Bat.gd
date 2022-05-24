extends KinematicBody2D

export var MAX_SPEED = 300
export var TO_MAX_TIME  = 0.1
export var TO_STOP_TIME = 0.5


onready var playerDetectionZone = $PlayerDetectionZone
onready var player = get_node("../Player")


enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var state = CHASE
var health = 30


func _physics_process(delta):
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, MAX_SPEED / TO_STOP_TIME * delta)
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var pdz = playerDetectionZone.player
			if pdz != null:
				var direction = (pdz.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, MAX_SPEED / TO_MAX_TIME * delta)
			else:
				state = IDLE
		
	velocity = move_and_slide(velocity)


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func check_if_alive():
	if health <= 0:
		queue_free()

func _on_HurtBox_area_entered(area):
	if area.name == "SwordHitBox":
		health -= player.attack_damage
		print("bat get damage, health = ", health)
		check_if_alive()
	else:
		print(area.name)
