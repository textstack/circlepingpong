extends Node2D

#var immuneNode = load("res://upgrades/immunity.tscn")
#var immuneSpawn
var ballNode = preload("res://objects/ball.tscn")
var ballsInGame = 0 # counter for current ball count
var ang = randf_range(-PI, PI)
var countdownTime = 6
var gamemode 
var disable_input: bool = false
var power_up = []	# List for powerups

@onready var gameMusic = $Music
@onready var endGameBoo = $EndGameSound
@onready var paddleHit = $PaddleHitSound
@onready var gameOverLabel = $EndGame/end_game/PanelContainer2/Countdown
@onready var gameOverTimer = $ResetTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Gamemode 
	var selected_mode = ModeAuto.getMode()
	if (selected_mode == 0):
		gamemode = BaseGamemode.new()
	if (selected_mode == 1):
		gamemode = EnduranceGamemode.new()
		$SpawnTimer.start()
		
	# ADD NEW POWERUPS HERE TO THE LIST
	#power_up.append(preload("res://upgrades/immunity.tscn"));
	#power_up.append(preload("res://upgrades/magnet.tscn"));
	power_up.append(preload("res://upgrades/slow_balls.tscn"));
	#power_up.append(preload("res://upgrades/x2points.tscn"));
	
	
	$"Game Mode"/game_mode.hide()
	$PauseMenu/pause_menu.hide()
	$EndGame/end_game.hide()
	
	gameMusic.play()

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

# Counts powerup in the scene
func power_up_count() -> int:
	var count = 0
	for child in get_tree().root.get_children():
		if child is power_up:
			count += 1
	return count
		
# Spawns immunity powerup
#func createImmune() -> void:
	#immuneSpawn = immuneNode.instantiate()
	#immuneSpawn.position = get_viewport_rect().size / 2
	#add_child(immuneSpawn)
	
# When the paddle hits a ball, update points and call a paddle animation
func onBallHit(ball, collision) -> void:
	paddleHit.play()
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
	disable_input = true
	endGameBoo.play()
	check_or_replace_highscore(gamemode.getPoints())
	gamemode.onGameOver()
	$EndGame/end_game.show()
	$EndGame/end_game/ScoreContainer/Score.text = "HIGH SCORE: " + str(High.highscore)
	$BallTimer.start()
	gameOverLabel.text = "RESTARTING IN ( %d )" % countdownTime
	$ResetTimer.start()
	
	$SpawnTimer.stop() 
	
	# Get rid of powerups in scene
	for child in get_tree().root.get_children():
		if child is power_up:
			child.queue_free()
	
	$EndGame/end_game.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($EndGame/end_game, "modulate", Color.WHITE, 0.5)
	tween.tween_callback($EndGame/end_game/PanelContainer.show)

func _input(event: InputEvent) -> void:
	if disable_input:
		# Ignore specific input when the game is over
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			return 

func check_or_replace_highscore(score : int) -> void:
	if High.highscore < score:
		High.highscore = score


# When the game is over, show the end game screen and start the countdown
func _on_ball_timer_timeout() -> void:
	pass

# Update countdown every second
func _on_reset_timer_timeout() -> void:
	$SpawnTimer.start()
	if countdownTime > 1:
		countdownTime -= 1
		gameOverLabel.text = "RESTARTING IN ( %d )" % countdownTime
	else:
		reset()
		
func _on_spawn_timer_timeout() -> void:
	if power_up_count() < 1:
		
		var rand = randi() % power_up.size()
		var power_instance = power_up[rand].instantiate()
		get_tree().root.add_child(power_instance)
		power_instance.position = get_viewport_rect().size / 2
	else:
		pass
	
	
func activate_power(power) -> void:
	power.apply_power_up(self) # This allows us to activate any power and makes power access to other
							   # code easy so we can make the powers happen
func slowBall() -> void:
	print("Hello")
	for child in get_tree().root.get_children():
		if child is Ball:
			child.halfSpeed()
	
func speedBall() -> void:
	print("Bye")
	for child in get_tree().root.get_children():
		if child is Ball:
			child.doubleSpeed()
