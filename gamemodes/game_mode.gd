extends Control

var gamemode

func _on_base_pressed() -> void:
	ModeAuto.setMode(0)
	get_tree().change_scene_to_file("res://main_scene.tscn")
	
func _on_endurance_pressed() -> void:
	ModeAuto.setMode(1)
	get_tree().change_scene_to_file("res://main_scene.tscn")
	
# Complete when Nux Mode implemented
func _on_nux_mode_pressed() -> void:
	pass # Replace with function body.
