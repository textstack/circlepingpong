extends Node2D

var velocity = Vector2(0, 0)
var lerpRotation = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateBG()
	setBG(delta)


func updateBG() -> void:
	var vel = Vector2(0, 0)
	var spin = 0
	for ball in get_tree().get_nodes_in_group("balls"):
		vel += ball.velocity
		spin += ball.curl
		
	lerpRotation -= spin * 0.1
	velocity = (velocity * 12 + vel) / 13


func setBG(delta: float) -> void:
	position = get_viewport_rect().size / 2
	rotation = (rotation * 4 + lerpRotation) / 5
	
	var vel = velocity.rotated(-rotation)
	$Grid1.position = $Grid1.position + vel * delta * 0.2
	$Grid2.position = $Grid2.position + vel * delta * 0.15
	$Grid3.position = $Grid3.position + vel * delta * 0.1
