extends Node2D

# Signal to activate instance from main
signal lose

# For exit on areabody2D
func _on_area_2d_body_exited(body: Node2D) -> void:
	var parent = body.get_parent()
	if parent is Ball and not parent.deleting:
		lose.emit()
		parent.prepareDelete()
