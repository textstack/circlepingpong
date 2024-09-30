extends power_up
class_name immunity

# Variables
var main_scene

# FUnction to apply the Immunity powerup
func apply_power_up(main):
	print("immunity")
	$PowerTime1.start()
	main_scene = main
	main.immunityBall()
	
	# Make powerup stay within boundary
	visible = false 
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)

# Function to make powerup stop
func deactivate_power():
	print("end immunity")
	main_scene.stopImmunityBall()
	self.queue_free()
