class_name StrengthArrow extends Node3D

@onready var ball = $"../.."
@onready var spring_arm = $"../../CameraPosition/SpringArm3D"
@onready var mesh = $ArrowMesh

func _ready():
	mesh.get_active_material(0).set_shader_parameter("max_hit_strength", ball.MAX_STRENGTH)

func _process(delta):
	if ball.get_is_aiming():
		show()
		rotate_to_camera()
		update_hit_strength()
	else:
		hide()

func rotate_to_camera():
	var tmp_rotation = spring_arm.get_rotation_basis()
	var tmp_position = ball.rigidbody.position
	if tmp_rotation and tmp_position:
		look_at(tmp_rotation + tmp_position) 
		rotation.x = 0 

func update_hit_strength():
	var current_shader_hit_strength = mesh.get_active_material(0).get_shader_parameter("hit_strength")
	var current_ball_hit_strength = ball.get_hit_strength()
	if current_shader_hit_strength != current_ball_hit_strength:
		mesh.get_active_material(0).set_shader_parameter("hit_strength", current_ball_hit_strength)
