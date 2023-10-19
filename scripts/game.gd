class_name Game extends Node3D

var puts

@export var ball : Golfball
@export var GUI : HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	puts = 0
	if !ball.putted.is_connected(on_putted):
		ball.putted.connect(on_putted)
	GUI.update_text(puts)


func on_putted():
	puts+=1
	GUI.update_text(puts)
