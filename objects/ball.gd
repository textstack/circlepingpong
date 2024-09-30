extends Node2D
class_name Ball

signal collide(ball, collision)

# configurables
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
var doMagnet = false
var paddle
var deleting = false
var modSpeed = 0

# Store the original collision layers and masks for the ball
var original_collision_layers = 0
var original_collision_masks = 0


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
		$PaddleSpinSound.play()
	else:
		$BallMdl/CurveTrail.emitting = false
		$BallMdl/BasicTrail.emitting = true
		$PaddleHitSound.play()

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
	
	if modSpeed > 0:
		velocity = velocity * (modSpeed / velocity.length())


func goTowardsPaddle():
	if not doMagnet:
		return
	
	if sideSpin != 0 or backSpin != Vector2(0, 0):
		return
	
	if Time.get_unix_time_from_system() - lastHit < 0.5:
		return
	
	var diff = paddle.position - position
	var length = velocity.length()
	velocity = velocity + diff * 0.1
	velocity = velocity * (length / velocity.length())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:	
	var collision = $BallMdl.get_last_slide_collision()
	if collision:
		onCollide(collision)
	
	velocity = velocity.rotated(sideSpin)
	velocity = velocity + backSpin
	
	goTowardsPaddle()
	
	$BallMdl.velocity = velocity
	$BallMdl.move_and_slide()


func _on_delete_timer_timeout() -> void:
	queue_free()


func _on_spin_timer_timeout() -> void:
	frontSpin = true
	$BallMdl/Spindicator.visible = true


# Reduces the speed of a ball by half
func halfSpeed() -> void:
	if modSpeed > 0:
		return
	
	modSpeed = velocity.length() / 2
	velocity = velocity * (modSpeed / velocity.length())
	print("Ball speed halved")


# Speeds up the by double
func doubleSpeed() -> void:
	if modSpeed <= 0:
		return
	
	velocity = velocity * 2
	modSpeed = 0
	print("Ball sped back up")

## TESTING
#func resetBallSpeeds() -> void:
	#for ball in main_scene.get_children():
		#if ball is Ball:
			#ball.doubleSpeed()

func magnetize(p) -> void:
	doMagnet = true
	paddle = p
	print("Ball has been magnetized")
	#Takes paddle object and turns magnet switch to true


func unMagnetize() -> void:
	doMagnet = false
	print("Ball has been demagnetized")
	#Turns Magnet Siwtch to False
	
func immunity() -> void:
	# Save the original collision layers and masks before modifying
	original_collision_layers = $BallMdl.collision_layer
	original_collision_masks = $BallMdl.collision_mask
	
	$BallMdl.set_collision_layer_value(2, true)
	$BallMdl.set_collision_mask_value(1, true)
	$BallMdl.set_collision_mask_value(4, true)
	$BallMdl.set_collision_mask_value(5, true)
	
	
	print("Ball is immune")
	
func noImmunity() -> void:
	$BallMdl.collision_layer = original_collision_layers
	$BallMdl.collision_mask = original_collision_masks
	print("Ball is no longer immune")
	
