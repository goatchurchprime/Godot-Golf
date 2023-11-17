class_name LevelSelect

extends Control

const LEVEL_BUTTON = preload("res://scenes/lvl_select_button.tscn")

signal change_level

@export_dir var path

@onready var container = $MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_files(path)

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
				if tmp == "test_level.tscn":
					tmp_name = "Test Level"
				create_button(tmp_path, tmp_name)
			else:
				dir.list_dir_end()
				break

func create_button(lvl_path, lvl_name):
	var btn = LEVEL_BUTTON.instantiate()
	btn.level_path = lvl_path
	btn.text = lvl_name
	btn.change_level.connect(change_level_func)
	container.add_child(btn)

func change_level_func(path, level_name):
	emit_signal("change_level", path, level_name)
