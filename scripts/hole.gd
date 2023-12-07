class_name Hole extends Area3D

signal game_win

@onready var camera = $SpringArm3D/HoleCamera
@onready var clapping_audio_player = $ClappingAudioPlayer

func _on_body_entered(body):
	var tmp_parent = body.get_parent()
	if tmp_parent is Golfball:
		game_win.emit(tmp_parent.get_multiplayer_authority())

func activate_hole_camera():
	camera.activate()
	clapping_audio_player.play()
