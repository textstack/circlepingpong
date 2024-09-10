extends Node2D
class_name Ball

signal collide

#configurables
var speedMult = 1.03
var curlChance = 17
var curlMin = 0.01
var curlMax = 0.03
var curlFactor = 0.06

var velocity = Vector2(0, 0)
var lastHit
var curl = 0
var collideCount = 0


func _init() -> void:
	lastHit = Time.get_unix_time_from_system()


func noMoreCollisions() -> void:
	$BallMdl/CollisionShape2D.disabled = true
	$DeleteTimer.start()


func tryEmitCollide(obj:Object) -> void:
	if curl != 0:
		curl = 0
	
	if obj.get_parent() is not Paddle:
		return
	
	if Time.get_unix_time_from_system() - lastHit < 0.25:
		return
	
	var doCurl = randi_range(0, curlChance - collideCount)
	if doCurl == 0:
		curl = 1
	elif doCurl == 1:
		curl = -1
	
	if curl != 0:
		collideCount = 0
		curl *= randf_range(curlMin, clamp(velocity.length() * curlFactor, curlMin, curlMax))
	
	collide.emit()
	lastHit = Time.get_unix_time_from_system()
	velocity = velocity * speedMult
	collideCount += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:	
	var collision = $BallMdl.get_last_slide_collision()
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		tryEmitCollide(collision.get_collider())

	if curl != 0:
		velocity = velocity.rotated(curl)
		$BallMdl/CurveTrail.emitting = true
		$BallMdl/BasicTrail.emitting = false
	else:
		$BallMdl/CurveTrail.emitting = false
		$BallMdl/BasicTrail.emitting = true

	$BallMdl.velocity = velocity
	$BallMdl.move_and_slide()


func _on_delete_timer_timeout() -> void:
	queue_free()
