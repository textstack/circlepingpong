extends power_up
class_name immunity

func apply_power_up(paddle):
	print("immunity")
	$PowerTime1.start()

func _on_power_time_timeout() -> void:
	pass # Unods Immunity Powers
