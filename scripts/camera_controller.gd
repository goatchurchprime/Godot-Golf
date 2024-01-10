extends Node3D

const SENSITIVITY = 0.25

@onready var ball = $"../.."
@onready var camera = $Camera3D

func _input(event):
	if event is InputEventMouseMotion and not ball.aiming:
		get_parent().rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		rotate_x(deg_to_rad(-event.relative.y) * SENSITIVITY)
		rotation.x = clamp(rotation.x, deg_to_rad(-50),deg_to_rad(10))

func get_rotation_basis():
	return get_parent().transform.basis.z

func set_arm_rotation(rot):
	get_parent().rotation.y = rot
