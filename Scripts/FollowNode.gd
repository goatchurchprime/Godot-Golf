extends Node3D

@export var LERP_WEIGHT : int

@export var follow : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin = lerp(transform.origin,follow.transform.origin,delta*LERP_WEIGHT)
