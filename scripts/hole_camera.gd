class_name HoleCamera extends Camera3D

@export_range(0.0001, 0.025, 0.001) var rotation_amt = deg_to_rad(0.07)

@onready var spring_arm = $".."

@export var active = false

func _process(delta):
	if active:
		spring_arm.rotate_y(rotation_amt)

func activate():
	make_current()
	active = true
