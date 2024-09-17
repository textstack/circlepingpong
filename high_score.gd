class_name High_score extends Node

var high_score

func _init() -> void:
	high_score = 0

# Updates highscore after every game if you have improved your score
func _update(score: int) -> void:
	if high_score < score:
		high_score = score

# Function for retriving the high score
func _retrieve() -> int:
	return high_score
