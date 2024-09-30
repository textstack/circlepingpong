extends Control

var gButton = preload("res://objects/gamemode_button.tscn")


func getAllFilePaths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += getAllFilePaths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	return file_paths


func makeButton(file: String):
	var gamemode = load(file).new()
	
	var inst = gButton.instantiate()
	inst.setGamemode(gamemode)
	$PanelContainer/VBoxContainer.add_child(inst)
	inst.pressed.connect(_on_button_pressed)


func _ready() -> void:
	var files = getAllFilePaths("res://gamemodes")
	for file in files:
		makeButton(file)


func _on_button_pressed(gamemode):
	ModeAuto.setMode(gamemode)
	get_tree().change_scene_to_file("res://main_scene.tscn")
