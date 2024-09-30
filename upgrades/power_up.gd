extends CharacterBody2D
class_name power_up # Base class for all powerups

#configurables
var maxCollides = 2

@export var speed = 120
var collides = 0


func _ready():
	$AnimatedSprite2D.play("default")
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed


# Function to determine the actions after collision
func _physics_process(delta: float):
	var collision = move_and_collide(velocity * delta) # get the collisoin
	
	if not collision:
		return
	
	var collider = collision.get_collider() # Get the collider (PaddlMdl)
	var paddle = collider.get_parent()      # Get the parent of collider (Paddle)
	
	# Make sure collider is apart of paddle group
	if collider.is_in_group("paddle"):
		powerup_effect(paddle)  # Pass Paddle instance into power_up
		#queue_free()
		#I had to stop queuing here because if we did the power wouldn't be able
		# to run down the timer and turn itself off
		
		return
	
	if collides <= maxCollides:
		velocity = velocity.bounce(collision.get_normal())
		collides += 1
	else:
		queue_free()


# Function to create the paddle glow powerup effect
func powerup_effect(paddle):
	print("Power-up activated!")
	paddle.isGlow = true # Mark the isPower variable in Paddle as true
	paddle.activate_glow(self) # sends power instance to paddle
