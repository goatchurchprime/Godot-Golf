extends Node3D

const SENSITIVITY = 0.25

@onready var ball = $"../../Golfball"
@onready var camera = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.make_current()

func _input(event):
	if event is InputEventMouseMotion and not ball.aiming:
		rotate_y(deg_to_rad(-event.relative.x) * SENSITIVITY)
		camera.rotate_x(deg_to_rad(-event.relative.y) * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-35),deg_to_rad(35))

func get_rotation_basis():
	return -transform.basis.y
