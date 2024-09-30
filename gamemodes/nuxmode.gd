extends EnduranceGamemode
class_name NuxMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speedMult = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Configurables
var hitsForPowerup = 3
var hitsIncrease = 2

var powerUps = []
var hitsNeeded = hitsForPowerup
var x2power = false
var hits = 0

func getName() -> String:
	return "Nux Mode"

func onBallHit(ball, _collision) -> void:
	points += 1
	ballPoints += 1

	# Slow down the ball by reducing its velocity by 3% (for example)
	ball.velocity = ball.velocity * 0.97
	
	if ballPoints >= determinePointsNeeded():
		mainScene.createBall()
		
	if hits > hitsForPowerup and powerUpCount() < 1:
		spawnPowerup()
		hits = 0
		hitsForPowerup += hitsIncrease
	else:
		hits += 1

	if x2power:
		points += 1


# Counts powerup in the scene
func powerUpCount() -> int:
	var count = 0
	for child in mainScene.get_children():
		if child is power_up:
			count += 1
	return count


func spawnPowerup() -> void:
	var rand = randi() % powerUps.size()
	var power_instance = powerUps[rand].instantiate()
	mainScene.add_child(power_instance)
	power_instance.position = mainScene.get_viewport_rect().size / 2


func onStart() -> void:
	super()
	powerUps.append(preload("res://upgrades/immunity.tscn"));
	powerUps.append(preload("res://upgrades/magnet.tscn"));
	powerUps.append(preload("res://upgrades/slow_balls.tscn"));
	powerUps.append(preload("res://upgrades/x2points.tscn"));


func cleanPowerups():
	for child in mainScene.get_children():
		if child is power_up:
			child.queue_free()


func onReset() -> void:
	super()
	cleanPowerups()
	hitsNeeded = hitsForPowerup


func onGameOver() -> void:
	super()
	cleanPowerups()

	
