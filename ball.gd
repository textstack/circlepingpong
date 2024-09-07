extends Node2D

var velocity = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision = $BallMdl.get_last_slide_collision()
	if collision:
		velocity = velocity.bounce(collision.get_normal())
	
	$BallMdl.velocity = velocity
	$BallMdl.move_and_slide()
