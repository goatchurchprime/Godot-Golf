class_name FireApplier extends Area3D

@export var fire_scene : PackedScene

func _on_body_entered(body):
	if body is RigidBody3D:
		var tmp = fire_scene.instantiate()
		body.add_child(tmp)
