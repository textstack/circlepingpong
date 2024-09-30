extends Node2D
class_name Ball

# Collision signal
signal collide(ball, collision)

# Configurable variables
var spinChance = 15
var sideSpinMin = 0.01
var sideSpinMax = 0.03
var sideSpinFactor = 0.06
var backSpinMin = 0.02
var backSpinMax = 0.03

# Variables
var sideSpin = 0
var collideCount = 0
var oldSpeed = 0
var modSpeed = 0
var velocity = Vector2(0, 0)
var backSpin = Vector2(0, 0)
var frontSpin = false
var doMagnet = false
var deleting = false
var lastHit
var paddle


# Store the original collision layers and masks for the immunity power
var original_collision_layers = 0
var original_collision_masks = 0

# Called when Ball is created
func _init() -> void:
	lastHit = Time.get_unix_time_from_system()

# Prepares the ball for deletion
func prepareDelete() -> void:
	sideSpin = 0                           # Reset variables to 0
	backSpin = Vector2(0, 0)
	$BallMdl/CurveTrail.emitting = false   # Disable trails
	$BallMdl/BasicTrail.emitting = false
	$BallMdl/CollisionShape2D.queue_free()
	$DeleteTimer.start()                   # Start the delete timer

# Logic for spin effects
func handleSpin() -> void:
	var doSpin = randi_range(0, spinChance - collideCount) # randomly decide spin
	
	# Different types of spins
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
	
	# Check for spin and apply visual effects
	if sideSpin != 0 or backSpin != Vector2(0, 0):
		$BallMdl/CurveTrail.emitting = true
		$BallMdl/BasicTrail.emitting = false
		collideCount = 0
		sideSpin *= randf_range(sideSpinMin, clamp(velocity.length() 
		* sideSpinFactor, sideSpinMin, sideSpinMax))
		backSpin *= randf_range(backSpinMin, backSpinMax)
		oldSpeed = velocity.length()
		$PaddleSpinSound.play()
	else:
		$BallMdl/CurveTrail.emitting = false
		$BallMdl/BasicTrail.emitting = true
		$PaddleHitSound.play()

	collideCount += 1 # Increment collide count

# Handles when the ball collides with an object
func onCollide(collision) -> void:
	velocity = velocity.bounce(collision.get_normal()) # Adjust velocity
	
	# Rest spin effects after a collision
	if sideSpin != 0 or backSpin != Vector2(0, 0):
		$BallMdl/CurveTrail.emitting = false
		$BallMdl/BasicTrail.emitting = true
		sideSpin = 0
		backSpin = Vector2(0, 0)
		velocity = velocity * (oldSpeed / velocity.length())
	
	# Check if collision was not with Paddle
	if collision.get_collider().get_parent() is not Paddle:
		return
	if Time.get_unix_time_from_system() - lastHit < 0.25:
		return
	
	handleSpin()
	collide.emit(self, collision)
	lastHit = Time.get_unix_time_from_system()
	if modSpeed > 0:
		velocity = velocity * (modSpeed / velocity.length())

# Function for 
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
	
