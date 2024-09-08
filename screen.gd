extends Node2D
class_name Screen

static var scrSize = 800

# get the radius of the circle the game takes place in
static func getCircleRadius() -> float:
	return scrSize * 0.4

static func getScreenSize() -> float:
	return scrSize
