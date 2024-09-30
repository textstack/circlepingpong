extends Control

@onready var buttonSound = $ButtonSound
@onready var titleMusic = $TitleMusic

# Play animations for info screen and hide info
func _ready() -> void:
	titleMusic.play()
	$Immunity.play("default")
	$Magnet.play("default")
	$SlowBalls.play("default")
	$x2Points.play("default")
	$Immunity.hide()
	$Magnet.hide() 
	$SlowBalls.hide() 
	$x2Points.hide()
	$ColorRect.hide()
	$InfoHeader.hide()
	$InfoBody.hide()
	
# Start button enters the game
func _on_start_button_pressed() -> void:
	buttonSound.play()
	get_tree().change_scene_to_file("res://gamemode.tscn")

# Quit closes the game
func _on_quit_pressed() -> void:
	buttonSound.play()
	get_tree().quit()

# When mouse hovers over info, show info
func _on_info_menu_mouse_entered() -> void:
	$Immunity.show()
	$Magnet.show() 
	$SlowBalls.show() 
	$x2Points.show()
	$ColorRect.show()
	$InfoHeader.show()
	$InfoBody.show()
	
# When mouse leave the icon, hide all
func _on_info_menu_mouse_exited() -> void:
	$Immunity.hide()
	$Magnet.hide() 
	$SlowBalls.hide() 
	$x2Points.hide()
	$ColorRect.hide()
	$InfoHeader.hide()
	$InfoBody.hide()
