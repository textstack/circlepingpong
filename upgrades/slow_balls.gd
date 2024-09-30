extends power_up
class_name slow_balls
var main_scene

func apply_power_up(main):
	print("slow balls")
	$PowerTime3.start()
	main_scene = main
	
	main.slowBall()
			
	visible = false # This is to make the object noninteractable until it unqueus itself
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)

func deactivate_power() -> void:
	print("end slow balls")
	main_scene.speedBall()
	self.queue_free()
