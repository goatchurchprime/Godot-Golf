extends Node3D

@export_range(-1, 1, 0.1) var rotation_amt = 0.25

@export var rotate_x_axis : bool
@export var rotate_y_axis : bool
@export var rotate_z_axis : bool

func _physics_process(delta):
	if rotate_x_axis:
		rotate_x(rotation_amt*delta)
	if rotate_y_axis:
		rotate_y(rotation_amt*delta)
	if rotate_z_axis:
		rotate_z(rotation_amt*delta)
