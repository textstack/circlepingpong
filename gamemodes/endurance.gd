extends BaseGamemode
class_name EnduranceGamemode

#configurables
var speedMult = 1.03
var pointsToNextBall = 5

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


func onShowPoints() -> String:
	var pointsLeft = determinePointsNeeded() - ballPoints
	return str(points, " (", pointsLeft, ")")


func onReset() -> void:
	super()
	ballPoints = 0


func onBallRemoved() -> void:
	ballPoints = determinePointsNeeded(1)
