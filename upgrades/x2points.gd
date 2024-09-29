extends power_up
class_name x2_points
var main_scene

func apply_power_up(main):
	print("x2Points")
	$PowerTime4.start()
	# I Put a flip in the modes that when true does a second point add
	main_scene = main
	main.gamemode.x2power = true
	visible = false # This is to make the object noninteractable until it unqueus itself
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)
	


func deactivate_powers() -> void:
	print("End x2Points")
	main_scene.gamemode.x2power = false
	self.queue_free() # Deactivates and Unqueus
