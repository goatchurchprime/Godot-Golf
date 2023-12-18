class_name LevelGroup extends Node3D

var hole : Hole
var spawn_location : SpawnLocation
var out_of_bounds_area : OutOfBoundsArea

signal golfball_won
signal golfball_out_of_bounds

func _ready():
	hole = $Hole
	spawn_location = $SpawnLocation
	out_of_bounds_area = $OutOfBoundsArea
	check_variables()
	hole.game_win.connect(game_win)
	out_of_bounds_area.golfball_left.connect(golfball_left)

func game_win(peer_id):
	golfball_won.emit(peer_id)

func golfball_left(peer_id):
	golfball_out_of_bounds.emit(peer_id)

func check_variables():
	if not Hole:
		print_error("Hole")
	if not spawn_location:
		print_error("Spawn Location")
	if not out_of_bounds_area:
		print_error("Out of Bounds Area")

func print_error(missing):
	print("ERROR - " + self.name + "IS MISSING: " + missing)

func activate_hole_camera():
	hole.activate_hole_camera()
