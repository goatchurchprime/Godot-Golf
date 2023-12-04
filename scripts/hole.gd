class_name Hole extends Area3D

signal game_win

@onready var camera = $SpringArm3D/HoleCamera
@onready var clapping_audio_player = $ClappingAudioPlayer

func _on_body_entered(body):
	if body.get_parent() is Golfball:
		game_win.emit()
		camera.activate()
		clapping_audio_player.play()
