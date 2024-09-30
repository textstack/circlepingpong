extends Node

# Var for gamemode setting
@onready var selected_mode = BaseGamemode.new()

func setMode(mode):
	selected_mode = mode
	
func getMode():
	return selected_mode
