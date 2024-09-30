extends Control

var tween

func _ready():
	$Circle.value = 100


func killTimer():
	if tween:
		tween.kill()


func startTimer(time, callback):
	killTimer()
	
	$Circle.value = 100
	tween = get_tree().create_tween()
	tween.tween_property($Circle, "value", 0, time)
	tween.tween_callback(callback)
