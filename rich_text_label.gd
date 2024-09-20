extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "[wave amp=180 freq=4][center]SERVE SPIN
SHOWDOWN[/center][/wave]"
	
	self.add_theme_font_size_override("normal_font_size", 150)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
