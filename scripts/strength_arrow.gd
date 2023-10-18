extends "res://scripts/follow_node.gd"

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
		rotate_to_camera()
		change_hit_strength()
		change_color()
	else:
		hide()

func rotate_to_camera():
	if head.spring_arm_rotation and head.ball_position:
		look_at(head.spring_arm_rotation+ head.ball_position) 
		rotation.x = 0

func change_hit_strength():
	mesh.scale.z = head.hit_strength/10
	mesh.position.z = -mesh.scale.z/2 + 0.1
	
func change_color():
	var color = clamp(int(abs(head.hit_strength*25)),0,255)
	material.albedo_color = Color8(color,0,0) 
