class_name NonPlayingArea extends Area3D

var golfball : Golfball

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if golfball:
		if golfball.get_is_stopped():
			print("MOVE GOLFBALL")
			Global.golball_left(golfball.get_multiplayer_authority())

func _on_body_entered(body):
	if body.get_parent() is Golfball:
		print("GOLFBALL ENTERED")
		golfball = body.get_parent()


func _on_body_exited(body):
	if body.get_parent() is Golfball:
		print("GOLFBALL EXITED")
		golfball = null
