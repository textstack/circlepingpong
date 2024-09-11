extends Node2D

signal lose


func _on_area_2d_body_exited(body: Node2D) -> void:
	var parent = body.get_parent()
	if parent is Ball:
		lose.emit()
		parent.prepareDelete()
