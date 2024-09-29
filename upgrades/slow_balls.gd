extends power_up
class_name slow_balls

func apply_power_up(paddle):
	print("slow balls")
	$PowerTime3.start()

func _on_power_time_3_timeout() -> void:
	pass # Undos Slow balls
