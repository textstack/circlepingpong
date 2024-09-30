extends BaseGamemode
class_name EnduranceGamemode

#configurables
var speedMult = 1.03
var pointsToNextBall = 5
var powerUps = []
var hits = 0
var hitsForPowerup = 3
var hitsIncrease = 1
var x2power = false

var ballPoints = 0

func _init() -> void:
	addSpeed = 4

func getName() -> String:
	return "Endurance"

func determinePointsNeeded(minus: int = 0) -> int:
	var pointsNeeded = 0
	for i in mainScene.ballsInGame - minus:
		pointsNeeded += pointsToNextBall * (i + 1)

	return pointsNeeded

func onBallHit(ball, _collision) -> void:
	points += 1
	ballPoints += 1
	ball.velocity = ball.velocity * speedMult
	
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


func onShowPoints() -> String:
	var pointsLeft = determinePointsNeeded() - ballPoints
	return str(points, " (", pointsLeft, ")")


func onReset() -> void:
	super()
	ballPoints = 0
	cleanPowerups()

func onBallRemoved() -> void:
	super()
	ballPoints = determinePointsNeeded(1)
	cleanPowerups()
	
func cleanPowerups():
	for child in mainScene.get_children():
		if child is power_up:
			child.queue_free()
