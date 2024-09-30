extends Control

# Variables
var tween

# Called when class starts
func _ready():
	$Circle.value = 100

# Stop timer
func killTimer():
	if tween:
		tween.kill()

# Start timer
func startTimer(time, callback):
	killTimer()
	$Circle.value = 100
	tween = get_tree().create_tween()
	tween.tween_property($Circle, "value", 0, time)
	tween.tween_callback(callback)
