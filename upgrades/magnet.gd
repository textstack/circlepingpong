extends power_up
class_name magnet

func apply_power_up(paddle):
	print("magnet")
	$PowerTime2.start()

func _on_power_time_2_timeout() -> void:
	pass # Unods Effects of magnet power
