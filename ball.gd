extends Node2D
class_name Ball

signal collide(collision)

#configurables
var speedMult = 1.03
var spinChance = 15
var sideSpinMin = 0.01
var sideSpinMax = 0.03
var sideSpinFactor = 0.06
var backSpinMin = 0.02
var backSpinMax = 0.03

var velocity = Vector2(0, 0)
var lastHit
var sideSpin = 0
var collideCount = 0
var backSpin = Vector2(0, 0)
var oldSpeed = 0


func _init() -> void:
	lastHit = Time.get_unix_time_from_system()


func prepareDelete() -> void:
	sideSpin = 0
	backSpin = Vector2(0, 0)
	$BallMdl/CurveTrail.emitting = false
	$BallMdl/BasicTrail.emitting = false
	$BallMdl/CollisionShape2D.queue_free()
	$DeleteTimer.start()


func handleSpin() -> void:
	var doSpin = randi_range(0, spinChance - collideCount)
	if doSpin == 0:
		sideSpin = 1
	elif doSpin == 1:
		sideSpin = -1
	elif doSpin == 2:
		backSpin = -velocity
	elif doSpin == 3:
		backSpin = velocity * 0.66
	
	if sideSpin != 0 or backSpin != Vector2(0, 0):
		$BallMdl/CurveTrail.emitting = true
		$BallMdl/BasicTrail.emitting = false
		collideCount = 0
		sideSpin *= randf_range(sideSpinMin, clamp(velocity.length() * sideSpinFactor, sideSpinMin, sideSpinMax))
		backSpin *= randf_range(backSpinMin, backSpinMax)
		oldSpeed = velocity.length()
	else:
		$BallMdl/CurveTrail.emitting = false
		$BallMdl/BasicTrail.emitting = true


func onCollide(collision) -> void:
	velocity = velocity.bounce(collision.get_normal())
	
	if sideSpin != 0 or backSpin != Vector2(0, 0):
		$BallMdl/CurveTrail.emitting = false
		$BallMdl/BasicTrail.emitting = true
		sideSpin = 0
		backSpin = Vector2(0, 0)
		velocity = velocity * (oldSpeed / velocity.length())
	
	if collision.get_collider().get_parent() is not Paddle:
		return
	
	if Time.get_unix_time_from_system() - lastHit < 0.25:
		return
	
	handleSpin()
	collide.emit(collision)
	lastHit = Time.get_unix_time_from_system()
	velocity = velocity * speedMult
	collideCount += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:	
	var collision = $BallMdl.get_last_slide_collision()
	if collision:
		onCollide(collision)
	
	velocity = velocity.rotated(sideSpin)
	velocity = velocity + backSpin

	$BallMdl.velocity = velocity
	$BallMdl.move_and_slide()


func _on_delete_timer_timeout() -> void:
	queue_free()
