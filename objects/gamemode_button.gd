extends Control

signal pressed(output)

var gamemode


func setGamemode(input):
	$Button.text = input.getName()
	gamemode = input


func _on_button_pressed() -> void:
	pressed.emit(gamemode)
