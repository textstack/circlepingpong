extends Node2D

var ballNode = preload("res://objects/ball.tscn")
var ballsInGame = 0 # counter for current ball count
var gamemode
var countdownTime = 6
@onready var endGameBoo = $EndGameSound
@onready var gameOverLabel = $EndGame/end_game/PanelContainer2/Countdown
@onready var gameOverTimer = $ResetTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PauseMenu/pause_menu.hide()
	$EndGame/end_game.hide()
	gamemode = EnduranceGamemode.new()
	gamemode.mainScene = self
	$Region.lose.connect(onRemoveBall)
	createBall()
	positioning()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	resetShift()


# Spawns a new ball
func createBall() -> void:
	ballsInGame += 1
	gamemode.onCreateBall()
	showPoints()
	
	var speed = gamemode.getBallSpeed()
	var ang = randf_range(-PI, PI)
	var inst = ballNode.instantiate()
	inst.position = get_viewport_rect().size / 2
	inst.velocity = Vector2(cos(ang) * speed, sin(ang) * speed)
	inst.collide.connect(onBallHit)
	add_child(inst)


# When the paddle hits a ball, update points and call a paddle animation
func onBallHit(ball, collision) -> void:
	gamemode.onBallHit(ball, collision)
	showPoints()
	sparkPaddle(collision)


# When a ball goes out of bounds, remove ball
func onRemoveBall() -> void:
	ballsInGame -= 1
	gamemode.onBallRemoved()
	showPoints()

	if ballsInGame <= 0:
		gameOver()


# Display points in the top left
func showPoints() -> void:
	$PointDisplay.text = gamemode.onShowPoints()


# Positioning the black inner circle
func positioning() -> void:
	var size = Screen.getCircleRadius() / 60
	$Region.scale = Vector2(size, size)
	$Region.position = get_viewport_rect().size / 2


# Paddle hit effect
func sparkPaddle(collision) -> void:
	position = position - collision.get_normal() * 3
	$PaddleSpark.rotation = $Paddle/PaddleMdl.rotation
	$PaddleSpark.position = collision.get_position()
	$PaddleSpark.emitting = true


# Reset the 3 pixel shift when the paddle hits a ball
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


# Reset the entire game
func reset() -> void:
	gamemode.onReset()
	
	# Reset points and balls
	for b in get_tree().get_nodes_in_group("balls"):
		b.queue_free()
	ballsInGame = 0
	countdownTime = 6
	$Background.lerpRotation = 0
	$ResetTimer.stop()
	showPoints()
	createBall()
	
	if $EndGame/end_game.visible:
		$EndGame/end_game/PanelContainer.hide()
		var tween = get_tree().create_tween()
		tween.tween_property($EndGame/end_game, "modulate", Color(255, 255, 255, 0), 0.5)
		tween.tween_callback($EndGame/end_game.hide)


# Called when the game has ended
func gameOver():
	endGameBoo.play()
	gamemode.onGameOver()
	$EndGame/end_game.show()
	$BallTimer.start()
	gameOverLabel.text = "RESTARTING IN ( %d )" % countdownTime
	$ResetTimer.start()
	
	$EndGame/end_game.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($EndGame/end_game, "modulate", Color.WHITE, 0.5)
	tween.tween_callback($EndGame/end_game/PanelContainer.show)


# When the game is over, show the end game screen and start the countdown
func _on_ball_timer_timeout() -> void:
	pass


# Update countdown every second
func _on_reset_timer_timeout() -> void:
	if countdownTime > 1:
		countdownTime -= 1
		gameOverLabel.text = "RESTARTING IN ( %d )" % countdownTime
	else:
		reset()
