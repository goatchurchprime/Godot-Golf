class_name OutOfBoundsArea extends Area3D

signal golfball_left

func _on_body_exited(body):
	var tmp_parent = body.get_parent()
	if tmp_parent is Golfball:
		golfball_left.emit(tmp_parent.get_multiplayer_authority())
