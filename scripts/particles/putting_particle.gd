class_name PuttingParticle extends GPUParticles3D

@onready var golfball = $"../.."

func _on_golfball_putted():
	rotation.x = golfball.spring_arm.get_rotation_basis().x
	restart()
