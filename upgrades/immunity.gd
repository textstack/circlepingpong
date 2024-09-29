extends power_up
class_name immunity

func apply_power_up(power):
	print("immunity")
	$PowerTime1.start()
	for child in get_node("res://main_scene").get_tree().root.get_children():
		if child is Ball:
			pass
	

func rescind_power_up():
	for child in get_node("res://main_scene").get_tree().root.get_children():
		if child is Ball:
			pass
