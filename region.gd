extends Node2D

signal lose

func _on_area_2d_body_exited(body: Node2D) -> void:
	lose.emit()
