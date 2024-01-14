class_name LevelSelect extends Control

const LEVEL_BUTTON = preload("res://scenes/lvl_select_button.tscn")

var level_groups : Array

var last_hole : bool

var current_level_group : LevelGroup

signal change_level_signal
signal game_won
signal golfball_left

var level_paths : Array

@export_dir var path

@onready var menu = $LevelContainer
@onready var container = $LevelContainer/MarginContainer/HBoxContainer/VBoxContainer

func _ready():
	get_files(path)
	menu.visible = false

func change_level(level_path, level_name):
	last_hole = false
	remove_current_level()
	initialize_level(level_path)

func remove_current_level():
	if current_level_group:
		get_tree().current_scene.remove_child(current_level_group.get_parent())
		current_level_group = null
	if level_groups:
		level_groups.clear()

func initialize_level(level_path):
	disconnect_signals()
	var tmp = load(level_path).instantiate()
	get_tree().current_scene.add_child(tmp)
	var tmp_children = tmp.get_children()
	for child in tmp_children:
		if child is LevelGroup:
			level_groups.append(child)
	level_groups.sort()

func disconnect_signals():
	if current_level_group:
		print("SIGNALS DISCONNECTED")
		if current_level_group.golfball_won.is_connected(game_win):
			current_level_group.golfball_won.disconnect(game_win)
		if current_level_group.golfball_out_of_bounds.is_connected(golfball_left_func):
			current_level_group.golfball_out_of_bounds.disconnect(golfball_left_func)

func connect_signals():
	if current_level_group:
		print("SIGNALS CONNECTED")
		current_level_group.golfball_won.connect(game_win)
		current_level_group.golfball_out_of_bounds.connect(golfball_left_func)

func next_hole():
	if not current_level_group:
			current_level_group = level_groups[0]
	else:
		disconnect_signals()
		for n in range(level_groups.size()):
			if current_level_group == level_groups[n]:
				if n == level_groups.size()-1:
					last_hole = true
					break
				current_level_group = level_groups[n+1]
				break
	connect_signals()

func activate_hole_camera():
	current_level_group.activate_hole_camera()

func golfball_left_func(peer_id):
	golfball_left.emit(peer_id)

func game_win(peer_id):
	game_won.emit(peer_id)

func change_level_func(level_path, level_name):
	change_level_signal.emit(level_path, level_name)

func get_current_spawn_location_transform():
	return current_level_group.spawn_location.global_transform

func get_files(path):
	if !path:
		print("Level select is missing folder")
		return
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				var tmp_path = dir.get_current_dir() + "/" + tmp
				# Fixes exporting map, removes suffix .remap
				tmp_path = tmp_path.trim_suffix(".remap")
				var tmp_name = get_name_from_path(tmp_path)
				print(tmp_path)
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

func get_name_from_path(tmp_path):
	var last_slash = tmp_path.rfind("/")
	var substring = tmp_path.substr(last_slash+1,tmp_path.length())
	substring = substring.trim_suffix(".tscn")
	substring = substring.replace("_"," ")
	return substring

func next_level_rotation():
	return current_level_group.spawn_location.global_rotation.y
