extends CharacterBody2D
class_name Immunity

@export var speed = 150

func _ready():
	$AnimatedSprite2D.play("default")
	
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed
	
func _physics_process(delta: float):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
	
		if collider.is_in_group("paddle"):
			powerup_effect(collider)
			queue_free()
			return
			
func powerup_effect(paddle):
	print(" ")	# placeholder for powerup
