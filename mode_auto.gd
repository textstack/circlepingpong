extends Node

# Var for gamemode setting
@onready var selected_mode = BaseGamemode.new()

# Setter
func setMode(mode):
	selected_mode = mode

# Getter
func getMode():
	return selected_mode
