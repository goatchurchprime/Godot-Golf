class_name Booster extends Area3D

@export_range(0.1, 2) var boost_strength = 2

func _on_body_entered(body):
	if body.get_parent() is Golfball:
		body.get_parent().impulse = Vector3(global_transform.basis.x.normalized()) * boost_strength
		print(body.get_parent().impulse)
