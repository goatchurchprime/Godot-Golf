extends Node3D

@export var LERP_WEIGHT : int
@export var followingNode : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow(delta)

func follow(delta):
	transform.origin = lerp(transform.origin,followingNode.transform.origin,delta*LERP_WEIGHT)
