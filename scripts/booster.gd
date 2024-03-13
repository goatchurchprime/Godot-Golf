class_name Booster extends Node3D

@export_range(0.1, 4, 0.1) var boost_strength = 2.0

@onready var boost_sound_player = $BoostAudioPlayer

func _on_booster_body_entered(body):
	var golfball_head = body.get_parent()
	if golfball_head is Golfball:
		var impulse = Vector3(global_transform.basis.z.normalized()) * boost_strength
		golfball_head.rigidbody.apply_impulse(impulse) 
		print(impulse)
		boost_sound_player.play()
