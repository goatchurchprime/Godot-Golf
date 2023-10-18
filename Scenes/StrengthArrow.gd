extends "res://Scripts/FollowNode.gd"

@onready var head = $".."
@onready var mesh = $ArrowMesh

var material = StandardMaterial3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh.material_override = material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow(delta)
	if head.aiming:
		show()
		rotate_to_springarm()
		change_hit_strength()
		change_color()
	else:
		hide()

func rotate_to_springarm():
	if head.springArmRotation and head.ballPosition:
		look_at(head.springArmRotation+ head.ballPosition) 
		rotation.x = 0

func change_hit_strength():
	mesh.scale.z = head.hitStrength/10
	mesh.position.z = -mesh.scale.z/2 + 0.1
	
func change_color():
	material.albedo_color = Color8(int(abs(head.hitStrength*20)),0,0) 
