extends BaseGamemode
class_name DefaultGamemode

#configurables
var hitsForPowerup = 5
var hitsIncrease = 1

var powerUps = []
var x2power = false
var hits = 0


func getName() -> String:
	return "Default"


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


func spawnPowerup() -> void:
	var rand = randi() % powerUps.size()
	var power_instance = powerUps[rand].instantiate()
	mainScene.add_child(power_instance)
	power_instance.position = mainScene.get_viewport_rect().size / 2


func onStart() -> void:
	super()
	#powerUps.append(preload("res://upgrades/immunity.tscn"));
	powerUps.append(preload("res://upgrades/magnet.tscn"));
	#powerUps.append(preload("res://upgrades/slow_balls.tscn"));
	powerUps.append(preload("res://upgrades/x2points.tscn"));


func cleanPowerups():
	for child in mainScene.get_children():
		if child is power_up:
			child.queue_free()


func onReset() -> void:
	super()
	cleanPowerups()


func onGameOver() -> void:
	super()
	cleanPowerups()
