extends power_up
class_name x2_points

# Variables
var main_scene

# Function to apply powrup
func apply_power_up(main):
	print("x2Points")
	$PowerTime4.start()
	main_scene = main
	main.gamemode.x2power = true
	
	# For the power up to collide and bounce off of boundary
	visible = false 
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)

# FUnction to turn off powerup
func deactivate_powers() -> void:
	print("End x2Points")
	main_scene.gamemode.x2power = false
	self.queue_free() 
