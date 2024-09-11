extends Node2D

var ball = preload("res://ball.tscn")
var ballsInGame = 0 # counter for current ball count
var gamemode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamemode = EnduranceGamemode.new()
	gamemode.mainScene = self
	$Region.lose.connect(onRemoveBall)
	createBall()
	positioning()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	resetShift()


# spawn a new ball
func createBall() -> void:
	ballsInGame += 1
	gamemode.onCreateBall()
	showPoints()
	
	var speed = gamemode.getBallSpeed()
	var ang = randf_range(-PI, PI)
	var inst = ball.instantiate()
	inst.position = get_viewport_rect().size / 2
	inst.velocity = Vector2(cos(ang) * speed, sin(ang) * speed)
	inst.collide.connect(onBallHit)
	add_child(inst)


# when the paddle hits a ball
func onBallHit(ball, collision) -> void:
	gamemode.onBallHit(ball, collision)
	showPoints()
	
	sparkPaddle(collision)


# when a ball goes out of bounds
func onRemoveBall() -> void:
	ballsInGame -= 1
	gamemode.onBallRemoved()
	showPoints()

	if ballsInGame <= 0:
		$BallTimer.start()


# display points in the top left
func showPoints() -> void:
	$PointDisplay.text = gamemode.onShowPoints()


# positioning the black inner circle
func positioning() -> void:
	var size = Screen.getCircleRadius() / 60
	$Region.scale = Vector2(size, size)
	$Region.position = get_viewport_rect().size / 2


# paddle hit effect
func sparkPaddle(collision) -> void:
	position = position - collision.get_normal() * 3
	$PaddleSpark.rotation = $Paddle/PaddleMdl.rotation
	$PaddleSpark.position = collision.get_position()
	$PaddleSpark.emitting = true


# reset the 3 pixel shift when the paddle hits a ball
var originalPos = position
var shifted = false
func resetShift() -> void:
	if position != originalPos:
		if shifted:
			position = originalPos
			shifted = false
		else:
			shifted = true
	else:
		shifted = false


# reset the entire game
func reset() -> void:
	gamemode.onReset()
	
	for b in get_tree().get_nodes_in_group("balls"):
		b.queue_free()
	ballsInGame = 0
	$Background.lerpRotation = 0
	showPoints()
	createBall()


func _on_ball_timer_timeout() -> void:
	reset()
