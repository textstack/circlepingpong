extends Node2D

var velocity = Vector2(0, 0)
var lerpRotation = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	updateBG()
	setBG(delta)


func updateBG() -> void:
	var vel = Vector2(0, 0)
	var sideSpin = 0
	for ball in get_tree().get_nodes_in_group("balls"):
		vel += ball.velocity
		sideSpin += ball.sideSpin
		
	lerpRotation -= sideSpin * 0.1
	velocity = (velocity * 12 + vel) / 13


var pos = Vector2(-10000, -10000)
func setBG(delta: float) -> void:
	position = get_viewport_rect().size / 2
	rotation = (rotation * 4 + lerpRotation) / 5
	
	pos = pos + velocity.rotated(-rotation) * delta
	$Grid1.position = pos * 0.18
	$Grid2.position = pos * 0.125
	$Grid3.position = pos * 0.08
