extends Node2D

# Variables
var ballNode = preload("res://objects/ball.tscn")
<<<<<<< HEAD
var ballsInGame = 0
var ang = randf_range(-PI, PI)       
var countdownTime = 6
var gamemode 
var disable_input: bool = false
var power_up = []
=======
var ballsInGame = 0 # counter for current ball count
var ang = randf_range(-PI, PI)
var gamemode
var disable_input: bool = false
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892

# On Ready variables
@onready var gameMusic = $Music
@onready var endGameBoo = $EndGameSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Gamemode 
<<<<<<< HEAD
	var selected_mode = ModeAuto.getMode()
	if (selected_mode == 0):
		gamemode = BaseGamemode.new()
	if (selected_mode == 1):
		gamemode = EnduranceGamemode.new()
		$SpawnTimer.start()
		
	# Adding powerups to the list
	power_up.append(preload("res://upgrades/immunity.tscn"));
	#power_up.append(preload("res://upgrades/magnet.tscn"));
	#power_up.append(preload("res://upgrades/slow_balls.tscn"));
	#power_up.append(preload("res://upgrades/x2points.tscn"));
	
	# Hide pause screen
	$"Game Mode"/game_mode.hide()
	$PauseMenu/pause_menu.hide()
	$EndGame/end_game.hide()
	
	# Starts game music
=======
	gamemode = ModeAuto.getMode()
	
	$Gamemode/gamemode.hide()
	$PauseMenu/pause_menu.hide()
	$EndGame/end_game.hide()
	
	$PauseMenu/pause_menu.reset.connect(reset)
	$EndGame/end_game.reset.connect(reset)
	
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
	gameMusic.play()

	# Remove current balls and spawn a new ball
	gamemode.mainScene = self
	gamemode.onStart()
	$Region.lose.connect(onRemoveBall)
	createBall()
	positioning()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	resetShift()

<<<<<<< HEAD
# Function that spawns a new ball
=======

# Spawns a new ball
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
func createBall() -> void:
	# Variables
	var speed = gamemode.getBallSpeed()
	var inst = ballNode.instantiate()
	ballsInGame += 1       
	
	# Update points and call ball from gamemode class
	gamemode.onCreateBall()
	showPoints()

	# Set the position, velocity and colliision of the ball
	inst.position = get_viewport_rect().size / 2
	inst.velocity = Vector2(cos(ang) * speed, sin(ang) * speed)
	inst.collide.connect(onBallHit)
	add_child(inst)

<<<<<<< HEAD
# Counts powerup in the scene
func power_up_count() -> int:
	var count = 0
	for child in get_tree().root.get_children():
		if child is power_up:
			count += 1
	return count
	
=======

>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
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
	
	# Conditional for end game
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
		b.deleting = true
		b.queue_free()
	
	ballsInGame = 0
	$Background.lerpRotation = 0
	showPoints()
	createBall()
	
<<<<<<< HEAD
	# Set the end game scene text
=======
	$EndGame/end_game/CircleMeter.killTimer()
	
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
	if $EndGame/end_game.visible:
		var tween = get_tree().create_tween()
		tween.tween_property($EndGame/end_game, "modulate", Color(1, 1, 1, 0), 0.5)
		tween.tween_callback($EndGame/end_game.hide)


# Called when the game has ended
func gameOver():
	disable_input = true
	endGameBoo.play()
	check_or_replace_highscore(gamemode.getPoints())
	gamemode.onGameOver()
	$EndGame/end_game.show()
	$EndGame/end_game/ScoreContainer/Score.text = "HIGH SCORE: " + str(High.highscore)
<<<<<<< HEAD
	$BallTimer.start()
	gameOverLabel.text = "RESTARTING IN ( %d )" % countdownTime
	$ResetTimer.start()
	$SpawnTimer.stop() 
	
	# Get rid of powerups in scene
	for child in get_tree().root.get_children():
		if child is power_up:
			child.queue_free()
=======
	$EndGame/end_game/CircleMeter.startTimer(8, reset)
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
	
	# Set the end game scene text
	$EndGame/end_game.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($EndGame/end_game, "modulate", Color.WHITE, 0.5)


# Allows user to right click to pause game
func _input(event: InputEvent) -> void:
	if disable_input:
		# Ignore specific input when the game is over
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			return 

<<<<<<< HEAD
# Conditional function to decide highscore
=======

>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
func check_or_replace_highscore(score : int) -> void:
	if High.highscore < score:
		High.highscore = score

<<<<<<< HEAD
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
		
# Timer to decide time of powerups
func _on_spawn_timer_timeout() -> void:
	
	# Conditional to spawn and remove powerups
	if power_up_count() < 1:
		
		# variables
		var rand = randi() % power_up.size()
		var power_instance = power_up[rand].instantiate()
		
		# Add powerup
		get_tree().root.add_child(power_instance)
		power_instance.position = get_viewport_rect().size / 2
	else:
		pass
	
# Activate any power & makes power allows access to other classes
func activate_power(power) -> void:
	power.apply_power_up(self) 
			
# Slows down balls
=======

func activate_power(power) -> void:
	power.apply_power_up(self) # This allows us to activate any power and makes power access to other
							   # code easy so we can make the powers happen


# This function calls the halfSpeed function in class "ball" when the powerup is gained
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
func slowBall() -> void:
	print("Slowing down all balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
<<<<<<< HEAD
			child.halfSpeed()                             # Halves the velocity of each ball
	
# Speeds up ball to original speed
=======
			child.halfSpeed()  # Halves the velocity of each ball


# This function calls the doubleSpeed function in class "ball" when the powerup time runsout
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
func speedBall() -> void:
	print("Speeding up all balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
			child.doubleSpeed()                           # Doubles the velocity of each ball

<<<<<<< HEAD
# Magnetizes ball
=======

>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
func magnetBall() -> void:
	print("Magnetizing all balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
<<<<<<< HEAD
			child.magnetize($Paddle)                      # Doubles the velocity of each ball

# Unmagnetizes ball
=======
			child.magnetize($Paddle)  # doubles the velocity of each ball


>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
func unMagnetBall() -> void:
	print("DeMagnetize all balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
<<<<<<< HEAD
			child.unMagnetize($Paddle)                    # Doubles the velocity of each ball
			
## Makes the player immune to losing a ball
func startImmunityBall() -> void:
		print("Start immunity")
		for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
			if child is Ball:
				child.startImmunity()                    # Doubles the velocity of each ball
			
## Stops the immunity power	
func stopImmunityBall() -> void:
		print("Stop immunity")
		for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
			if child is Ball:
				child.stopImmunity()                    # Doubles the velocity of each ball
=======
			child.unMagnetize()  # doubles the velocity of each ball
>>>>>>> 2fc55027e1e51ba3a30fc5ffbb2e381225526892
