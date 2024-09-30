# This class is the base gamemode class
# It implements one ball only with no powerups
extends Node
class_name BaseGamemode

# configurables for speed
var baseSpeed = 150
var addSpeed = 7

# points
var points = 0
var mainScene

# Get the name of this gamemode for the button
func getName() -> String:
	return "One Ball"

# Ball speed when ball collides with paddle
func onBallHit(ball, _collision) -> void:
	points += 1
	ball.velocity = ball.velocity * (getBallSpeed() / ball.velocity.length())

# Function for showing the points of game in string
func onShowPoints() -> String:
	return str(points)

# Getter for points as an int
func getPoints() -> int:
	return points

# Getter for the ball speed
func getBallSpeed() -> int:
	return baseSpeed + addSpeed * points

# Resets points after game lost
func onReset() -> void:
	points = 0

# All below function are for game modes other than base
func onGameOver() -> void:
	pass


func onBallRemoved() -> void:
	pass


func onCreateBall() -> void:
	pass


func onStart() -> void:
	pass
