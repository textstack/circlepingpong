extends Node2D
class_name Ball

signal collide(collision)

#configurables
var speedMult = 1.03
var curlChance = 15
var curlMin = 0.01
var curlMax = 0.03
var curlFactor = 0.06
var backSpinMin = 0.02
var backSpinMax = 0.03

var velocity = Vector2(0, 0)
var lastHit
var curl = 0
var collideCount = 0
var backSpin = Vector2(0, 0)
var oldSpeed = 0


func _init() -> void:
	lastHit = Time.get_unix_time_from_system()


func prepareDelete() -> void:
	curl = 0
	backSpin = Vector2(0, 0)
	$BallMdl/CurveTrail.emitting = false
	$BallMdl/BasicTrail.emitting = false
	$BallMdl/CollisionShape2D.queue_free()
	$DeleteTimer.start()


func handleCurl() -> void:
	var doCurl = randi_range(0, curlChance - collideCount)
	if doCurl == 0:
		curl = 1
	elif doCurl == 1:
		curl = -1
	elif doCurl == 2:
		backSpin = velocity * -randf_range(backSpinMin, backSpinMax)
	
	if curl != 0 or backSpin != Vector2(0, 0):
		$BallMdl/CurveTrail.emitting = true
		$BallMdl/BasicTrail.emitting = false
		collideCount = 0
		curl *= randf_range(curlMin, clamp(velocity.length() * curlFactor, curlMin, curlMax))
		oldSpeed = velocity.length()
	else:
		$BallMdl/CurveTrail.emitting = false
		$BallMdl/BasicTrail.emitting = true


func onCollide(collision) -> void:
	velocity = velocity.bounce(collision.get_normal())
	
	if curl != 0 or backSpin != Vector2(0, 0):
		$BallMdl/CurveTrail.emitting = false
		$BallMdl/BasicTrail.emitting = true
		curl = 0
		backSpin = Vector2(0, 0)
		velocity = velocity * (oldSpeed / velocity.length())
	
	if collision.get_collider().get_parent() is not Paddle:
		return
	
	if Time.get_unix_time_from_system() - lastHit < 0.25:
		return
	
	handleCurl()
	collide.emit(collision)
	lastHit = Time.get_unix_time_from_system()
	velocity = velocity * speedMult
	collideCount += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:	
	var collision = $BallMdl.get_last_slide_collision()
	if collision:
		onCollide(collision)
	
	velocity = velocity.rotated(curl)
	velocity = velocity + backSpin

	$BallMdl.velocity = velocity
	$BallMdl.move_and_slide()


func _on_delete_timer_timeout() -> void:
	queue_free()
