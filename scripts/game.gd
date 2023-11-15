class_name Game extends Node3D

const BALL_SCENE = preload("res://scenes/golfball.tscn")

var puts

@export var GUI : HUD
@export var level_select : LevelSelect

var hole : Area3D
var ball : Golfball
var current_level : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(false)
	reset_stats()
	
	
	if !level_select.change_level.is_connected(change_level):
		level_select.change_level.connect(change_level)

func reset_stats():
	puts = 0
	GUI.update_text(puts)

func on_putted():
	puts+=1
	GUI.update_text(puts)

func change_level(path):
	remove_current_level()
	initialize_level(path)
	remove_old_ball()
	add_ball()
	reset_stats()
	change_state(true)

func ball_collision(node):
	if node is Golfball:
		var tmpChildren = node.get_parent().get_children()
		for child in tmpChildren:
			if child is FollowNode:
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
	var tmpChildren = tmp.get_children()
	for child in tmpChildren:
		if child is RigidBody3D:
			ball = child
			if !ball.putted.is_connected(on_putted):
				ball.putted.connect(on_putted)
			continue

func initialize_level(path):
	current_level = load(path).instantiate()
	get_tree().current_scene.add_child(current_level)
	var tmpChildren = current_level.get_children()
	for child in tmpChildren:
		if child is Area3D:
			hole = child
			if !hole.body_entered.is_connected(ball_collision):
				hole.body_entered.connect(ball_collision)

func remove_current_level():
	if current_level:
		current_level.get_parent().remove_child(current_level)
