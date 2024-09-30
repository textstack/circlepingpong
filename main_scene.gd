extends Node2D

# Variables
var ballNode = preload("res://objects/ball.tscn")
var ballsInGame = 0 # counter for current ball count
var ang = randf_range(-PI, PI)
var gamemode
var disable_input: bool = false

# On Ready variables
@onready var gameMusic = $Music
@onready var endGameBoo = $EndGameSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Gamemode 
	gamemode = ModeAuto.getMode()
	
	# Hide pause screen
	$Gamemode/gamemode.hide()
	$PauseMenu/pause_menu.hide()
	$EndGame/end_game.hide()
	
	# Connect Pause and End Screen
	$PauseMenu/pause_menu.reset.connect(reset)
	$EndGame/end_game.reset.connect(reset)
	
	# Start music
	gameMusic.play()

	# Start main game functions
	gamemode.mainScene = self
	gamemode.onStart()
	$Region.lose.connect(onRemoveBall)
	createBall()
	positioning()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	resetShift()

# Spawns a new ball
func createBall() -> void:
	# Variables
	var speed = (450 + gamemode.getBallSpeed()) / 4
	var inst = ballNode.instantiate()
	
	# Functions to create a new ball
	ballsInGame += 1
	gamemode.onCreateBall()
	showPoints()
	inst.position = get_viewport_rect().size / 2
	inst.velocity = Vector2(cos(ang) * speed, sin(ang) * speed)
	inst.targetSpeed = gamemode.getBallSpeed()
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
		b.deleting = true
		b.queue_free()
	ballsInGame = 0
	$Background.lerpRotation = 0
	showPoints()
	createBall()
	$EndGame/end_game/CircleMeter.killTimer()
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
	$EndGame/end_game/CircleMeter.startTimer(8, reset)
	$EndGame/end_game.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($EndGame/end_game, "modulate", Color.WHITE, 0.5)

# Allows the user to pause the game by right-clicking
func _input(event: InputEvent) -> void:
	if disable_input:
		# Ignore specific input when the game is over
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			return 

# Function to decide highscore to display
func check_or_replace_highscore(score : int) -> void:
	if High.highscore < score:
		High.highscore = score

# Activates the powerups
func activate_power(power) -> void:
	power.apply_power_up(self) # This allows us to activate any power and makes power access to other
							   # code easy so we can make the powers happen

# Function calls the halfSpeed function in class "ball" when the powerup is gained
func slowBall() -> void:
	print("Slowing down all balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
			child.halfSpeed()  # Halves the velocity of each ball

# Function calls the doubleSpeed function in class "ball" when the powerup time runsout
func speedBall() -> void:
	print("Speeding up all balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
			child.doubleSpeed()  # Doubles the velocity of each ball

# Function calls magnetize in class "ball" for powerup
func magnetBall() -> void:
	print("Magnetizing all balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
			child.magnetize($Paddle)  # Magnetizes ball

# Function calls unMagnetize in class "ball" for powerup
func unMagnetBall() -> void:
	print("DeMagnetize all balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
			child.unMagnetize()  # Unmagnetizes ball

# Function calls imunity in class "ball" for powerup
func immunityBall() -> void:
	print("Immunity for balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
			child.immunity()  # Makes ball immune
			
# Function calls noImmunity in class "ball" for powerup
func stopImmunityBall() -> void:
	print("Immunity for balls")
	for child in get_tree().get_nodes_in_group("balls"):  # Ensure all balls are in the "balls" group
		if child is Ball:
			child.noImmunity()  # Stops ball's immunity
