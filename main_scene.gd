extends Node2D

var immuneNode = load("res://upgrades/immunity.tscn")
var immuneSpawn
var ballNode = preload("res://objects/ball.tscn")
var ballsInGame = 0 # counter for current ball count
var ang = randf_range(-PI, PI)
@onready var gamemode 
@onready var endGameBoo = $EndGameSound
@onready var gameOverLabel = $"End Game/end_game/PanelContainer2/Countdown"
@onready var gameOverTimer = $ResetTimer
@onready var countdown_time = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#immuneSpawn = $Path2D/PathFollow2D
	
	$SpawnTimer.start()
	$"Pause Menu"/pause_menu.hide()
	$"End Game"/end_game.hide()
	$"Game Mode"/game_mode.hide()
	
	# Gamemode 
	var selected_mode = ModeAuto.getMode()
	if (selected_mode == 0):
		gamemode = BaseGamemode.new()
	if (selected_mode == 1):
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
	var inst = ballNode.instantiate()
	inst.position = get_viewport_rect().size / 2
	inst.velocity = Vector2(cos(ang) * speed, sin(ang) * speed)
	inst.collide.connect(onBallHit)
	add_child(inst)

# Spawns immunity powerup
func createImmune() -> void:
	immuneSpawn = immuneNode.instantiate()
	immuneSpawn.position = get_viewport_rect().size / 2
	add_child(immuneSpawn)
	
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
		$BallTimer.start()

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
	$Background.lerpRotation = 0
	showPoints()
	createBall()

# When the game is over, show the end game screen and start the countdown
func _on_ball_timer_timeout() -> void:
	endGameBoo.play()
	get_tree().paused = true
	$"End Game"/end_game.show()
	gameOverLabel.text = "RESTART IN ( %d )" % countdown_time  # Set countdown start value
	$ResetTimer.start()

# Update countdown every second
func _on_reset_timer_timeout() -> void:
	
	# If countdown has not run out, continue to update the second
	if countdown_time > 1:
		countdown_time -= 1
		gameOverLabel.text = "RESTART IN ( %d )" % countdown_time
		
	# If the countdown has run out, reset the game
	else:
		$"End Game"/end_game.hide()
		get_tree().paused = false
		get_tree().reload_current_scene()
		
func _on_spawn_timer_timeout() -> void:
	createImmune()
