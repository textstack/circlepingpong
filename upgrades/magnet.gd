extends power_up
class_name magnet

# Variables
var main_scene

# Function to apply Magnet powerup
func apply_power_up(main):
	print("magnet")
	$PowerTime2.start()
	main_scene = main
	main.magnetBall()
	
	# Makes powerup stay within boundary
	visible = false
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)

# FUnction to stop powerup
func deactivate_power():
	print("end magnet")
	main_scene.unMagnetBall()
	self.queue_free()
