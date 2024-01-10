class_name GolfballRigidbody extends RigidBody3D

const WISH_POS_SKIN = 2

var wish_pos
var do_goto = false

func goto(pos):
	wish_pos = pos
	do_goto = true

func _integrate_forces(state):
	if do_goto:
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		var wish_state = state.get_transform()
		wish_state = wish_pos
		wish_state.origin.y += WISH_POS_SKIN
		state.set_transform(wish_state)
		do_goto = false
