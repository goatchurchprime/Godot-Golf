extends Node3D

@export_range(0.1, 1, 0.1) var rotation_amt = 0.25

@export var rotate_x_axis : bool
@export var rotate_y_axis : bool
@export var rotate_z_axis : bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rotate_x_axis:
		rotate_x(rotation_amt*delta)
	if rotate_y_axis:
		rotate_y(rotation_amt*delta)
	if rotate_z_axis:
		rotate_z(rotation_amt*delta)
