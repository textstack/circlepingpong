extends Node2D

var ball = preload("res://ball.tscn")
var baseSpeed = 100
var addSpeed = 10
var ballCount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createBall()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func createBall() -> void:
	var speed = baseSpeed + addSpeed * ballCount
	var ang = randf_range(-PI, PI)
	ballCount += 1
	
	var inst = ball.instantiate()
	inst.position = get_viewport_rect().size / 2
	inst.velocity = Vector2(cos(ang) * speed, sin(ang) * speed)
	add_child(inst)

func _on_ball_timer_timeout() -> void:
	createBall()
