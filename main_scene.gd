extends Node2D

#configurables
var baseSpeed = 150
var addSpeed = 2
var subtract = 5

var ball = preload("res://ball.tscn")
var points = 0
var ballsInGame = 0
var totalPoints = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Region.lose.connect(removePoints)
	createBall()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var size = Screen.getCircleRadius() / 60
	$Region.scale = Vector2(size, size)
	$Region.position = get_viewport_rect().size / 2

func createBall() -> void:
	var speed = baseSpeed + addSpeed * totalPoints
	var ang = randf_range(-PI, PI)
	ballsInGame += 1
	
	var inst = ball.instantiate()
	inst.position = get_viewport_rect().size / 2
	inst.velocity = Vector2(cos(ang) * speed, sin(ang) * speed)
	inst.collide.connect(addPoints)
	add_child(inst)
	
func showPoints() -> void:
	$PointDisplay.text = str(totalPoints, " (", points, ")")
	
func addPoints() -> void:
	points += 1
	totalPoints += 1
	showPoints()
	
	if points % subtract == 0:
		createBall()
	
func removePoints() -> void:
	ballsInGame -= 1
	totalPoints -= 1
	points -= subtract
	showPoints()
	
	if ballsInGame <= 0:
		$BallTimer.start()

func _on_ball_timer_timeout() -> void:
	points = 0
	totalPoints = 0
	showPoints()
	createBall()
