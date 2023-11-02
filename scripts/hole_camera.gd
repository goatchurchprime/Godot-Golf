extends Camera3D

@onready var spring_arm = $".."

const ROTATION_SPEED = 0.003

var active : bool


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		spring_arm.rotate_y(ROTATION_SPEED)

func activate():
	make_current()
	active = true
