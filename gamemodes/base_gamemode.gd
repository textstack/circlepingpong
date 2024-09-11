extends Node
class_name BaseGamemode

#configurables
var baseSpeed = 150
var addSpeed = 4

var points = 0
var mainScene


func onBallHit(ball, collision) -> void:
	points += 1
	ball.velocity = ball.velocity * (getBallSpeed() / ball.velocity.length())


func onShowPoints() -> String:
	return str(points)


func getPoints() -> int:
	return points


func getBallSpeed() -> int:
	return baseSpeed + addSpeed * points


func onReset() -> void:
	points = 0


func onBallRemoved() -> void:
	pass


func onCreateBall() -> void:
	pass
