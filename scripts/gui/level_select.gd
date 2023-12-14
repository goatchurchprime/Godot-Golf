class_name LevelSelect

extends Control

const LEVEL_BUTTON = preload("res://scenes/lvl_select_button.tscn")

var current_level : Node3D
var current_level_name : String
var hole : Hole
var out_of_bounds_area : OutOfBoundsArea

signal change_level_signal
signal levels_found
signal game_won
signal golfball_left

var level_paths : Array

@export_dir var path

@onready var menu = $LevelContainer
@onready var container = $LevelContainer/MarginContainer/HBoxContainer/VBoxContainer

func _ready():
	get_files(path)
	levels_found.emit(level_paths)
	menu.visible = false

func change_level(path, level_name):
	current_level_name = level_name
	remove_current_level()
	initialize_level(path)

func remove_current_level():
	if current_level:
		current_level.get_parent().remove_child(current_level)

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
			if !out_of_bounds_area.golfball_left.is_connected(golfball_left_func):
				out_of_bounds_area.golfball_left.connect(golfball_left_func)

func game_win(peer_id):
	hole.activate_hole_camera()
	game_won.emit(peer_id)

func end_game():
	hole.activate_hole_camera()

func golfball_left_func(peer_id):
	golfball_left.emit(peer_id)

func change_level_func(path, level_name):
	change_level_signal.emit(path, level_name)

func get_files(path):
	if !path:
		print("Level select is missing folder")
		return
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var lvl_count = 0
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				lvl_count += 1
				var tmp_path = dir.get_current_dir() + "/" + tmp
				# Fixes exporting map, adds suffix .remap at the end
				tmp_path = tmp_path.trim_suffix(".remap") 
				var tmp_name = "Level " + str(lvl_count)
				create_button(tmp_path, tmp_name)
			else:
				dir.list_dir_end()
				break

func create_button(lvl_path, lvl_name):
	level_paths.append(lvl_path)
	var btn = LEVEL_BUTTON.instantiate()
	btn.level_path = lvl_path
	btn.text = lvl_name
	btn.change_level.connect(change_level_func)
	container.add_child(btn)

func activate():
	menu.visible = true
