class_name HoleCamera extends Camera3D

const ROTATION_AMT = deg_to_rad(0.07)

@onready var spring_arm = $".."

var active = false

func _process(delta):
	if active:
		spring_arm.rotate_y(ROTATION_AMT)

func activate():
	make_current()
	active = true
