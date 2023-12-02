class_name Hole extends Area3D

signal game_win

@onready var camera = $SpringArm3D/HoleCamera

func _on_body_entered(body):
	if body is Golfball:
		print("you won")
		game_win.emit()
		camera.activate()
