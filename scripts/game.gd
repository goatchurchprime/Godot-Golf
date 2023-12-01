class_name Game extends Node3D

const BALL_SCENE = preload("res://scenes/golfball.tscn")

var putts
var highscores = {}

@export var GUI : HUD
@export var level_select : LevelSelect

var hole : Area3D
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
	putts += 1
	GUI.update_text(putts)


func change_level(path, level_name):
	current_level_name = level_name
	remove_current_level()
	initialize_level(path)
	remove_old_ball()
	add_ball()
	reset_stats()
	change_state(true)


func game_win(node):
	var tmp_children = node.get_parent().get_children()
	for child in tmp_children:
		if child is FollowNode:
#			add_high_score(current_level_name)
			child.setNodeToFollow(hole)
			ball.get_parent().visible = false
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
		get_tree().current_scene.remove_child(ball.get_parent())
		ball = null


func add_ball():
	var tmp = BALL_SCENE.instantiate()
	get_tree().current_scene.add_child(tmp)
	var tmp_children = tmp.get_children()
	for child in tmp_children:
		if child is RigidBody3D:
			ball = child
			if !ball.putted.is_connected(on_putted):
				ball.putted.connect(on_putted)
			continue


func initialize_level(path):
	current_level = load(path).instantiate()
	get_tree().current_scene.add_child(current_level)
	var tmp_children = current_level.get_children()
	for child in tmp_children:
		if child is Hole:
			hole = child
			if !hole.body_entered.is_connected(game_win):
				hole.body_entered.connect(game_win)


func remove_current_level():
	if current_level:
		current_level.get_parent().remove_child(current_level)
