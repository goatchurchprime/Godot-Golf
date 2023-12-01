extends Node3D

const SENSITIVITY = 0.25

@onready var ball = $"../../Golfball"
@onready var camera = $Camera3D

func _ready():
	camera.make_current()


func _input(event):
	if event is InputEventMouseMotion and not ball.aiming:
		get_parent().rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		rotate_x(deg_to_rad(-event.relative.y) * SENSITIVITY)
		rotation.x = clamp(rotation.x, deg_to_rad(-50),deg_to_rad(10))


func get_rotation_basis():
	return -get_parent().transform.basis.x.rotated(Vector3.UP, deg_to_rad(90))
