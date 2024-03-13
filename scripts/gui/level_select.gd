class_name LevelSelect extends Control

const LEVEL_BUTTON = preload("res://scenes/lvl_select_button.tscn")

var last_hole : bool

var level_groups : Array
var current_level_group : LevelGroup

@export_dir var path
@onready var container = $LevelContainer/MarginContainer/VBoxContainer

func _ready():
	Global.register(self)
	if !path:
		print("Level select is missing folder")
		return
	var levels = FileFetcherSingleton.get_scenes_in_path(path)
	for level in levels:
		create_button(level, get_name_from_path(level))
	

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
	var tmp = ResourceLoader.load(level_path).instantiate()
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
		if current_level_group.golfball_out_of_bounds.is_connected(golfball_left):
			current_level_group.golfball_out_of_bounds.disconnect(golfball_left)

func connect_signals():
	if current_level_group:
		print("SIGNALS CONNECTED")
		current_level_group.golfball_out_of_bounds.connect(golfball_left)
		current_level_group.golfball_won.connect(game_win)

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

func golfball_left(peer_id):
	Global.golball_left(peer_id)

func game_win(peer_id):
	Global.player_won(peer_id)

func change_level_func(level_path, level_name):
	Global.change_level(level_path, level_name)

func get_current_spawn_location_transform():
	return current_level_group.spawn_location.global_transform

func create_button(lvl_path, lvl_name):
	var btn = LEVEL_BUTTON.instantiate()
	btn.level_path = lvl_path
	btn.text = lvl_name
	btn.change_level.connect(change_level_func)
	container.add_child(btn)

func get_name_from_path(tmp_path):
	var last_slash = tmp_path.rfind("/")
	var substring = tmp_path.substr(last_slash+1,tmp_path.length())
	substring = substring.trim_suffix(".tscn")
	substring = substring.replace("_"," ")
	substring = substring.capitalize()
	return substring

func next_level_rotation():
	return current_level_group.spawn_location.global_rotation.y
