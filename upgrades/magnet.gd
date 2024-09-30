extends power_up
class_name magnet
var main_scene


func apply_power_up(main):
	print("magnet")
	$PowerTime2.start()
	main_scene = main
	
	main.magnetBall()
	
	visible = false # This is to make the object noninteractable until it unqueus itself
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)


func deactivate_power():
	print("end magnet")
	main_scene.unMagnetBall()
	self.queue_free()
