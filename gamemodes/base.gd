extends Node
class_name BaseGamemode

#configurables
var baseSpeed = 150
var addSpeed = 7

var points = 0
var mainScene

var x2power = false


func getName() -> String:
	return "One Ball"


func onBallHit(ball, _collision) -> void:
	points += 1
	if x2power:
		points+=1
	ball.velocity = ball.velocity * (getBallSpeed() / ball.velocity.length())


func onShowPoints() -> String:
	return str(points)


func getPoints() -> int:
	return points


func getBallSpeed() -> int:
	return baseSpeed + addSpeed * points


func onReset() -> void:
	points = 0


func onGameOver() -> void:
	pass


func onBallRemoved() -> void:
	pass


func onCreateBall() -> void:
	pass
