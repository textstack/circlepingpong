extends Control

# Signal to activate instance from main
signal pressed(output)

# Variables
var gamemode

# Function to set the gamemode for button pressed
func setGamemode(input):
	$Button.text = input.getName()
	gamemode = input

# Find button pressed
func _on_button_pressed() -> void:
	pressed.emit(gamemode)
