class_name FollowNode extends Node3D

const LERP_MULTIPLIER = 8

@export var use_lerp : bool
@export_range(0, 1, 0.1) var LERP_WEIGHT : float
@export var following_node : Node

var snap : bool

func _process(delta):
	if not use_lerp or snap:
		snap = false
		follow_exact()
	else:
		follow_lerp(delta)

func follow_lerp(delta):
	transform.origin = lerp(transform.origin, following_node.transform.origin, delta*LERP_WEIGHT*LERP_MULTIPLIER)

func set_node_to_follow(node):
	following_node = node

func follow_exact():
	transform.origin = following_node.transform.origin

func snap_to_pos():
	snap = true
