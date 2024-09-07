extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func orientPaddle(pos: Vector2) -> void:
	var center = get_viewport_rect().size / 2
	var diff = pos - center

	var ang = atan(diff.y / diff.x)
	if pos.x < center.x:
		ang += PI
	
	var mag = min(center.x, center.y) * 0.8
	
	$PaddleMdl.position = center + Vector2(cos(ang) * mag, sin(ang) * mag)
	$PaddleMdl.rotation = ang + PI/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mousePos = get_viewport().get_mouse_position()
	orientPaddle(mousePos)	
