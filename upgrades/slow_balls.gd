extends power_up
class_name slow_balls

func apply_power_up(power):
	print("slow balls")
	$PowerTime3.start()
	

func rescind_power_up():
	pass
