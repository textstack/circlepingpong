extends Node2D
class_name Screen

# Variables
static var scrSize = 800

# Get the radius of the circle the game takes place in
static func getCircleRadius() -> float:
	return scrSize * 0.4

# Get screen size
static func getScreenSize() -> float:
	return scrSize
