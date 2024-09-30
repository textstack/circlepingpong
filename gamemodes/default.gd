# Default gamemode with all balls and all powerups
extends EnduranceGamemode
class_name DefaultGamemode

#configurables
var hitsForPowerup = 3
var hitsIncrease = 2

var powerUps = []
var hitsNeeded = hitsForPowerup
var x2power = false
var hits = 0

# getter for the name of the gamemode
func getName() -> String:
	return "Default"

# when ball hits 
func onBallHit(ball, _collision) -> void:
	super(ball, _collision)

	if hits > hitsForPowerup and powerUpCount() < 1:
		spawnPowerup()
		hits = 0
		hitsForPowerup += hitsIncrease
	else:
		hits += 1
	
	if x2power:
		points += 1


# Counts powerup in the scene
func powerUpCount() -> int:
	var count = 0
	for child in mainScene.get_children():
		if child is power_up:
			count += 1
	return count

# spawn powerups randomly and instantiates them
func spawnPowerup() -> void:
	var rand = randi() % powerUps.size()
	var power_instance = powerUps[rand].instantiate()
	mainScene.add_child(power_instance)
	power_instance.position = mainScene.get_viewport_rect().size / 2

# load all powerups into the gamemode
func onStart() -> void:
	super()
	powerUps.append(preload("res://upgrades/immunity.tscn"));
	powerUps.append(preload("res://upgrades/magnet.tscn"));
	powerUps.append(preload("res://upgrades/slow_balls.tscn"));
	powerUps.append(preload("res://upgrades/x2points.tscn"));

# delete powerups
func cleanPowerups():
	for child in mainScene.get_children():
		if child is power_up:
			child.queue_free()

# reset and delete powerups
func onReset() -> void:
	super()
	cleanPowerups()
	hitsNeeded = hitsForPowerup

# when game ends
func onGameOver() -> void:
	super()
	cleanPowerups()
