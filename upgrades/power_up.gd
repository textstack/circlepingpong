extends CharacterBody2D
class_name power_up # Base class for all powerups

@export var speed = 120

func _ready():
	$AnimatedSprite2D.play("default")
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed
	
# Function to determine the actions after collision
func _physics_process(delta: float):
	var collision = move_and_collide(velocity * delta) # get the collisoin

	# If the collision happens
	if collision:
		var collider = collision.get_collider() # Get the collider (PaddlMdl)
		var paddle = collider.get_parent()      # Get the parent of collider (Paddle)
		
		# Make sure collider is apart of paddle group
		if collider.is_in_group("paddle"):
			powerup_effect(paddle)  # Pass Paddle instance into power_up
			queue_free()
			
			return
		velocity = velocity.bounce(collision.get_normal())
			
# Function to create the powerup effect
func powerup_effect(paddle):
	print("Power-up activated!")
	paddle.isGlow = true # Mark the isPower variable in Paddle as true
	paddle.activate_glow()


	
