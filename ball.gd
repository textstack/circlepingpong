extends Node2D
class_name Ball

signal collide

var velocity = Vector2(0, 0)
var lastHit
var curl = 0

func _init() -> void:
	lastHit = Time.get_unix_time_from_system()

func tryEmitCollide() -> void:
	if Time.get_unix_time_from_system() - lastHit < 0.25:
		return
	
	if curl != 0:
		curl = 0
	
	var doCurl = randi_range(0, 13)
	if doCurl == 0:
		curl += randf_range(0.01, 0.03)
	elif doCurl == 1:
		curl -= randf_range(0.01, 0.03)
	
	collide.emit()
	lastHit = Time.get_unix_time_from_system()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision = $BallMdl.get_last_slide_collision()
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 1.06
		tryEmitCollide()
		
	velocity = velocity.rotated(curl)
	
	$BallMdl.velocity = velocity
	$BallMdl.move_and_slide()
