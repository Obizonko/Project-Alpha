extends Position2D


onready var collisionShape = $SwordHitBox/CollisionShape2D

func _ready():
	collisionShape.disabled = true
