class_name GolfballAudioPlayer extends Node3D

enum states {GLIDING, IMPACT, IN_AIR}

var status = states.IN_AIR

@onready var golfball_rigidbody = $".."/Golfball

# Called when the node enters the scene tree for the first time.
func _ready():
	print(golfball_rigidbody)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
