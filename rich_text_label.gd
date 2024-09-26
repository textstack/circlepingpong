extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "[wave amp=180 freq=5][center]SERVE SPIN
SHOWDOWN[/center][/wave]"
	
	self.add_theme_font_size_override("normal_font_size", 150)
