extends Node3D

const SENSITIVITY = 0.25

# Lock camera when aiming

@onready var head = $"../.."
@onready var camera = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	head.springArmRotation = -transform.basis.y

func _input(event):
	if event is InputEventMouseMotion and not head.aiming:
		rotate_y(deg_to_rad(-event.relative.x) * SENSITIVITY)
		camera.rotate_x(deg_to_rad(-event.relative.y) * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-35),deg_to_rad(35))
		head.springArmRotation = -transform.basis.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
