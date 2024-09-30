extends Node2D
class_name Ball

signal collide(ball, collision)

#configurables
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
var frontSpin = false
var magnet = false
var paddle

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
	if frontSpin:
		frontSpin = false
		$BallMdl/Spindicator.visible = false
		backSpin = velocity * 0.75
	elif doSpin == 0:
		sideSpin = 1
	elif doSpin == 1:
		sideSpin = -1
	elif doSpin == 2:
		backSpin = -velocity
	elif doSpin == 3:
		$SpinTimer.start()
	
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

	collideCount += 1


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
	collide.emit(self, collision)
	lastHit = Time.get_unix_time_from_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:	
	var collision = $BallMdl.get_last_slide_collision()
	if collision:
		onCollide(collision)
	
	velocity = velocity.rotated(sideSpin)
	velocity = velocity + backSpin
	
	#Switch For magnetising velocity to paddle
	if magnet:
		pass

	$BallMdl.velocity = velocity
	$BallMdl.move_and_slide()

func _on_delete_timer_timeout() -> void:
	queue_free()

func _on_spin_timer_timeout() -> void:
	frontSpin = true
	$BallMdl/Spindicator.visible = true
	
# Reduces the speed of a ball by half
func halfSpeed() -> void:
	velocity *= 0.5
	print("Ball speed halved")
	
# Speeds up the by double
func doubleSpeed() -> void:
	velocity *= 2
	print("Ball sped back up")

func magnetize(p) -> void:
	magnet = true
	paddle = p
	print("Ball Has been Magnetized")
	#Takes paddle object and turns magnet switch to true

func unMagnetize(p) -> void:
	magnet = false
	print("Ball Has been DeMagnetized")
	#Turns Magnet Siwtch to False
