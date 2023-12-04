class_name OutOfBoundsArea extends Area3D

signal golfball_left

func _on_body_exited(body):
	if body.get_parent() is Golfball:
		golfball_left.emit()
