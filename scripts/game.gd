class_name Game extends Node3D

const BALL_SCENE = preload("res://scenes/golfball.tscn")

var putts
var highscores = {}

@export var GUI : HUD
@export var level_select : LevelSelect

var golfball_last_pos : Vector3
var out_of_bounds_area : OutOfBoundsArea

var hole : Hole
var ball : Golfball
var current_level : Node3D
var current_level_name : String

func _ready():
	change_state(false)
	reset_stats()
	
	if !level_select.change_level.is_connected(change_level):
		level_select.change_level.connect(change_level)


func reset_stats():
	putts = 0
	GUI.update_text(putts)

func on_putted():
	golfball_last_pos = ball.rigidbody.position
	putts += 1
	GUI.update_text(putts)


func change_level(path, level_name):
	current_level_name = level_name
	remove_current_level()
	initialize_level(path)
	add_ball()
	reset_stats()
	change_state(true)


func game_win():
	remove_old_ball()
	change_state(false)


func change_state(game_active):
	if game_active:
		GUI.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		level_select.visible = false
	else:
		GUI.visible = false
		level_select.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func remove_old_ball():
	if ball:
		get_tree().current_scene.remove_child(ball)
		ball = null


func add_ball():
	ball = BALL_SCENE.instantiate()
	get_tree().current_scene.add_child(ball)
	ball.putted.connect(on_putted)


func initialize_level(path):
	current_level = load(path).instantiate()
	get_tree().current_scene.add_child(current_level)
	var tmp_children = current_level.get_children()
	for child in tmp_children:
		if child is Hole:
			hole = child
			if !hole.game_win.is_connected(game_win):
				hole.game_win.connect(game_win)
		if child is OutOfBoundsArea:
			out_of_bounds_area = child
			if !out_of_bounds_area.golfball_left.is_connected(golfball_left):
				out_of_bounds_area.golfball_left.connect(golfball_left)

func golfball_left():
	ball.move_back(golfball_last_pos)


func remove_current_level():
	if current_level:
		current_level.get_parent().remove_child(current_level)
