class_name HoleCamera extends Camera3D

@export_range(0.1, 1, 0.1) var rotation_amt = 0.25

@onready var spring_arm = $".."

@export var active = false

func _process(delta):
	if active:
		spring_arm.rotate_y(rotation_amt*delta)

func activate():
	make_current()
	active = true
