class_name RotateNode extends Node3D

@export_range(-20, 20, 0.5) var seconds_per_rotation = 5

@export var rotate_x_axis : bool
@export var rotate_y_axis : bool
@export var rotate_z_axis : bool

func _physics_process(delta):
	var rotation_amount = (2*PI)/seconds_per_rotation * delta
	if rotate_x_axis:
		rotate_x(rotation_amount)
	if rotate_y_axis:
		rotate_y(rotation_amount)
	if rotate_z_axis:
		rotate_z(rotation_amount)
