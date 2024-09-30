extends Control

@onready var buttonSound = $ButtonSound
@onready var titleMusic = $TitleMusic


func _ready() -> void:
	titleMusic.play()


func _on_start_button_pressed() -> void:
	buttonSound.play()
	get_tree().change_scene_to_file("res://gamemode.tscn")


func _on_quit_pressed() -> void:
	buttonSound.play()
	get_tree().quit()
