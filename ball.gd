extends Node2D

signal collide

var velocity = Vector2(0, 0)
var lastHit

func _init() -> void:
	lastHit = Time.get_unix_time_from_system()

func tryEmitCollide() -> void:
	if Time.get_unix_time_from_system() - lastHit < 0.25:
		return
	
	collide.emit()
	lastHit = Time.get_unix_time_from_system()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision = $BallMdl.get_last_slide_collision()
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		tryEmitCollide()
	
	$BallMdl.velocity = velocity
	$BallMdl.move_and_slide()
