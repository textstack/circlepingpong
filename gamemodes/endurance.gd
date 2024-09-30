extends BaseGamemode
class_name EnduranceGamemode

# Configurable Variables
var speedMult = 1.03
var pointsToNextBall = 5

# Variables
var ballPoints = 0

# Called when Endurance Game Mode starts
func _init() -> void:
	addSpeed = 4

# Getter for current game mode
func getName() -> String:
	return "Endurance"

# Determine point for next ball spawn
func determinePointsNeeded(minus: int = 0) -> int:
	var pointsNeeded = 0
	for i in mainScene.ballsInGame - minus:
		pointsNeeded += pointsToNextBall * (i + 1)
	return pointsNeeded

# Called when a ball hits something
func onBallHit(ball, _collision) -> void:
	points += 1
	ballPoints += 1
	ball.velocity = ball.velocity * speedMult
	if ballPoints >= determinePointsNeeded():
		mainScene.createBall()

# Show the points in the top left corner
func onShowPoints() -> String:
	var pointsLeft = determinePointsNeeded() - ballPoints
	return str(points, " (", pointsLeft, ")")

# Resets 
func onReset() -> void:
	super()
	ballPoints = 0

# Remoces balls
func onBallRemoved() -> void:
	super()
	ballPoints = determinePointsNeeded(1)
