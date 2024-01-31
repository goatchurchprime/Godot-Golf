class_name Booster extends Node3D

@export_range(0.1, 4, 0.1) var boost_strength = 2.0

func _on_booster_body_entered(body):
	if body.get_parent() is Golfball:
		body.get_parent().impulse = Vector3(global_transform.basis.z.normalized()) * boost_strength
		print(body.get_parent().impulse)
