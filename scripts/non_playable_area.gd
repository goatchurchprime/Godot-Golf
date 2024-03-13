class_name NonPlayingArea extends Area3D

var golfballs : Array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for golfball in golfballs:
		if golfball.get_is_stopped():
			Global.golball_left(golfball.get_multiplayer_authority())

func _on_body_entered(body):
	if body.get_parent() is Golfball:
		if not golfballs.has(body.get_parent()):
			golfballs.append(body.get_parent())

func _on_body_exited(body):
	if body.get_parent() is Golfball:
		if golfballs.has(body.get_parent()):
			golfballs.erase(body.get_parent())
