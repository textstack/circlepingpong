extends Node2D
class_name Paddle

# Variable to control the glow effect
var isGlow: bool = false

# Reference to the WorldEnvironment node
@onready var world_env = $"WorldEnvironment"  # Adjust the path if needed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mousePos = get_viewport().get_mouse_position()
	orientPaddle(mousePos)
	
	# Check if the power-up is active and control the world glow
	enable_world_glow(isGlow)

# Function to orient the paddle
func orientPaddle(pos: Vector2) -> void:
	var center = get_viewport_rect().size / 2
	var mag = Screen.getCircleRadius()
	var diff = pos - center

	var ang = atan(diff.y / diff.x)
	if pos.x < center.x:
		ang += PI
	
	position = center + Vector2(cos(ang) * mag, sin(ang) * mag)
	$PaddleMdl.rotation = ang - PI/2
	
# Function to control the WorldEnvironment glow
func enable_world_glow(enable: bool) -> void:
	if world_env:
		if enable:
			world_env.environment.glow_enabled = true  # Set to your desired intensity
		else:
			world_env.environment.glow_enabled = false  # Disable the glow
