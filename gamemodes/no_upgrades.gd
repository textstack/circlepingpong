extends BaseGamemode
class_name NoUpgradesGamemode

#configurables
var pointsToNextBall = 5

var ballPoints = 0


func determinePointsNeeded(minus: int = 0) -> int:
	var pointsNeeded = 0
	for i in mainScene.ballsInGame - minus:
		pointsNeeded += pointsToNextBall * (i + 1)

	return pointsNeeded


func onBallHit(collision) -> void:
	super(collision)
	ballPoints += 1
	
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
