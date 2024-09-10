extends Node2D

#configurables
var baseSpeed = 150
var addSpeed = 4
var subtract = 5

var ball = preload("res://ball.tscn")
var points = 0 # the parenthesized points number
var ballsInGame = 0 # counter for current ball count
var totalPoints = 0 # the unparenthesized points number


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Region.lose.connect(removePoints)
	createBall()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var size = Screen.getCircleRadius() / 60
	$Region.scale = Vector2(size, size)
	$Region.position = get_viewport_rect().size / 2


func createBall() -> void:
	var speed = baseSpeed + addSpeed * totalPoints
	var ang = randf_range(-PI, PI)

	ballsInGame += 1
	showPoints()
	
	var inst = ball.instantiate()
	inst.position = get_viewport_rect().size / 2
	inst.velocity = Vector2(cos(ang) * speed, sin(ang) * speed)
	inst.collide.connect(addPoints)
	add_child(inst)


func determinePointsNeeded(minus: int = 0) -> int:
	var pointsNeeded = 0
	for i in ballsInGame - minus:
		pointsNeeded += subtract * (i + 1)

	return pointsNeeded


func showPoints() -> void:
	var pointsLeft = determinePointsNeeded() - points
	$PointDisplay.text = str(totalPoints, " (", pointsLeft, ")")


func addPoints() -> void:
	points += 1
	totalPoints += 1
	showPoints()
	
	if points >= determinePointsNeeded():
		createBall()


func removePoints() -> void:
	ballsInGame -= 1
	totalPoints -= 1
	
	points = determinePointsNeeded(1)
	showPoints()
	
	if ballsInGame <= 0:
		$BallTimer.start()


func _on_ball_timer_timeout() -> void:
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.queue_free()
	points = 0
	totalPoints = 0
	ballsInGame = 0
	$Background.lerpRotation = 0
	showPoints()
	createBall()
