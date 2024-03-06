extends Node3D

const SENSITIVITY = 0.25

const LERP_WEIGHT = 1
const MAX_FOV_OFFSET = 20

const VELOCITY_THRESHOLD = 6

@onready var ball = $"../.."
@onready var camera = $Camera3D
@onready var standard_fov = camera.fov
@onready var moving_camera_fov = standard_fov + MAX_FOV_OFFSET

func _input(event):
	if event is InputEventMouseMotion and not ball.get_is_aiming():
		get_parent().rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		rotate_x(deg_to_rad(-event.relative.y) * SENSITIVITY)
		rotation.x = clamp(rotation.x, deg_to_rad(-50),deg_to_rad(10))

func _physics_process(delta):
	var rigidbody_velocity = abs(ball.rigidbody.linear_velocity.length())
	camera.fov = lerp(camera.fov, standard_fov + rigidbody_velocity, delta * LERP_WEIGHT)
	camera.fov = clamp(camera.fov, standard_fov, moving_camera_fov)

func get_rotation_basis():
	return get_parent().transform.basis.z

func set_arm_rotation(rot):
	get_parent().rotation.y = rot
