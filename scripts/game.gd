class_name Game extends Node3D

var puts

@export var ball : Golfball
@export var GUI : HUD
@export var hole : Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	puts = 0
	
	if !ball.putted.is_connected(on_putted):
		ball.putted.connect(on_putted)
	
	if !hole.body_entered.is_connected(ball_collision):
		hole.body_entered.connect(ball_collision)
	
	GUI.update_text(puts)

func on_putted():
	puts+=1
	GUI.update_text(puts)

func ball_collision(node):
	if node is Golfball:
		ball.get_parent().queue_free()
		var tmpChildren = hole.get_children()
		for child in tmpChildren:
			if child is SpringArm3D:
				var cam = child.get_child(0)
				if cam is Camera3D:
					cam.activate()
