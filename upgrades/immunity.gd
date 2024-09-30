extends power_up
class_name immunity
var main_scene


func apply_power_up(main):
	print("immunity")
	$PowerTime1.start()
	main_scene = main
	main.immunityBall()
	
	visible = false # This is to make the object noninteractable until it unqueus itself
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)


func deactivate_power():
	print("end immunity")
	main_scene.stopImmunityBall()
	self.queue_free()
