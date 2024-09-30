extends Control

@onready var buttonSound = $ButtonSound
@onready var titleMusic = $TitleMusic
@onready var infoMenu = $info_menu_panel/info_menu
@onready var panelContainer = $info_menu_panel
@onready var infoTextBody = $info_body


func _ready() -> void:
	titleMusic.play()
<<<<<<< Updated upstream


=======
	infoMenu.hide()
	panelContainer.hide()
	infoTextBody.hide()
	$info_body2.hide()
	$Immunity.play("default")
	$Magnet.play("default")
	$SlowBalls.play("default")
	$x2Points.play("default")
	$Immunity.hide()
	$Magnet.hide() 
	$SlowBalls.hide() 
	$x2Points.hide()
	
>>>>>>> Stashed changes
func _on_start_button_pressed() -> void:
	buttonSound.play()
	get_tree().change_scene_to_file("res://gamemode.tscn")


func _on_quit_pressed() -> void:
	buttonSound.play()
	get_tree().quit()

func _on_info_button_mouse_entered() -> void:
	infoMenu.show()
	panelContainer.show()
	infoTextBody.show()
	$Immunity.show()
	$Magnet.show() 
	$SlowBalls.show() 
	$x2Points.show()
	$info_body2.show()
	
func _on_info_button_mouse_exited() -> void:
	infoMenu.hide()
	panelContainer.hide()
	infoTextBody.hide()
	$Immunity.hide()
	$Magnet.hide() 
	$SlowBalls.hide() 
	$x2Points.hide()
	$info_body2.hide()
