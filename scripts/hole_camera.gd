extends Camera3D

@onready var spring_arm = $".."

const ROTATION_SPEED = 0.002

var active : bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		spring_arm.rotate_y(ROTATION_SPEED)

func activate():
	make_current() #Take over camera for viewport
	active = true
