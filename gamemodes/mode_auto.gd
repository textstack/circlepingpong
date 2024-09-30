extends Node

# Var for gamemode setting
var selected_mode: int = 0

func setMode(mode:int):
	selected_mode = mode
	
func getMode() -> int:
	return selected_mode
