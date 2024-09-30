extends Control

# Signal to activate instance from main
signal reset

# Variables
var doReset = false

# End game screen when the player loses all balls
# Change ball timer time in main scene to increase/decrease 
# when the end screen shows
func _ready() -> void:
	var _size = Screen.getCircleRadius() / 600
	self.scale = Vector2(_size, _size)
	self.position = get_viewport_rect().size * _size * 0.45

# Function for restart button
func _on_restart_pressed() -> void:
	reset.emit()

# Function for quit button
func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
