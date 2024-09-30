extends power_up
class_name slow_balls

# Variables
var main_scene

# Apply the powerup
func apply_power_up(main):
	print("slow balls")
	$PowerTime3.start()
	main_scene = main
	main.slowBall()
	
	# For powerup to not leave boundary
	visible = false
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)

# Function to turn off powerup
func deactivate_power() -> void:
	print("end slow balls")
	main_scene.speedBall()
	self.queue_free()
