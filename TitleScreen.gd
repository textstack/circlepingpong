extends Control


func _on_start_b_utton_pressed() -> void:
	get_tree().change_scene_to_file("res://main_scene.tscn")
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
