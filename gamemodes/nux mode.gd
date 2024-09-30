extends EnduranceGamemode
class_name NuxMode

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#speedMult = 1
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
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
	
func getName() -> String:
	return "Nux Mode"
