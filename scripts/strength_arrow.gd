class_name StrengthArrow extends Node3D

@onready var ball = $"../.."
@onready var spring_arm = $"../../CameraPosition/SpringArm3D"
@onready var mesh = $ArrowMesh


func _process(delta):
	if ball.aiming:
		show()
		rotate_to_camera()
		change_hit_strength()
		change_color()
	else:
		hide()


func rotate_to_camera():
	var tmp_rotation = spring_arm.get_rotation_basis()
	var tmp_position = ball.rigidbody.position
	if tmp_rotation and tmp_position:
		look_at(tmp_rotation + tmp_position) 
		rotation.x = 0 


func change_hit_strength():
	mesh.scale.z = ball.hit_strength/10
	mesh.position.z = -mesh.scale.z/2 + 0.1


func change_color():
	var color = clamp(int(abs(ball.hit_strength*25)),0,255)
	mesh.get_active_material(0).albedo_color = Color8(color,0,0) 
