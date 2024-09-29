extends power_up
class_name magnet

func apply_power_up(power):
	print("magnet")
	$PowerTime2.start()

func rescind_power_up():
	pass
