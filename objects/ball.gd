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
var doMagnet = false
var paddle
var deleting = false
var modSpeed = 0


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


<<<<<<< HEAD
func unMagnetize(paddle) -> void:
	
	print("Ball Has been DeMagnetized")
	
func startImmunity() -> void:
	# Print message for debug
	print("Ball is now immune and will bounce off the region")
#
	# Adjust the collision layer and mask to make the ball immune to specific collisions
	# Set which collision layers this ball belongs to
	
	# Set the collision mask for this ball (which layers it can collide with)
	$BallMdl.set_collision_layer_value(2, true)
	$BallMdl.set_collision_mask_value(1, true)
	$BallMdl.set_collision_mask_value(4, true)
	$BallMdl.set_collision_mask_value(5, true)
	
func stopImmunity() -> void:
	# Print message for debug
	print("Ball is no longer immune")

	# Revert the collision layer and mask to allow the ball to interact with other layers again

	# Set the ball's original collision layer (assuming it belongs to layer 1, adjust if necessary)
	#$BallMdl.set_collision_layer_value(1, true)  # Restore collision layer for normal interaction
#
	## Re-enable collision mask to interact with all necessary layers (adjust based on your game setup)
	## Assume that the ball should collide with layers 1, 2, and 3 (for example):
	#$BallMdl.set_collision_mask_value(1, true)  # Re-enable collision with layer 1
	#$BallMdl.set_collision_mask_value(2, true)  # Re-enable collision with layer 2
	#$BallMdl.set_collision_mask_value(3, true)  # Re-enable collision with layer 3
	# Disable any other layers you don't want the ball to collide with anymore
	
	# Assuming the original layer value was 1, and we need to disable layer 2 (used in immunity)
	$BallMdl.set_collision_layer_value(2, false)  # Disable the immunity collision layer

	# Revert the collision mask values to what they were before startImmunity()
	$BallMdl.set_collision_mask_value(1, false)  # Disable collision with layer 1
	$BallMdl.set_collision_mask_value(4, false)  # Disable collision with layer 4
	$BallMdl.set_collision_mask_value(5, false)  # Disable collision with layer 5


	

	
	
=======
func magnetize(p) -> void:
	doMagnet = true
	paddle = p
	print("Ball has been magnetized")
	#Takes paddle object and turns magnet switch to true


func unMagnetize() -> void:
	doMagnet = false
	print("Ball has been demagnetized")
	#Turns Magnet Siwtch to False
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
