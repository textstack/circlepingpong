extends power_up
class_name x2_points

func apply_power_up(paddle):
	print("x2Points")
	$PowerTime4.start()
	
func _on_power_time_4_timeout() -> void:
	pass # Undos 2XPoints
