extends CanvasLayer

const LEVEL_BUTTON = preload("res://scenes/lvl_select_button.tscn")

@export_dir var path

@onready var container = $Control/MarginContainer/VBoxContainer

var buttons

# Called when the node enters the scene tree for the first time.
func _ready():
	get_files(path)

func get_files(path):
	if !path:
		print("Level select is missing folder")
		return
	var level_names = Array()
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var lvl_count = 0
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				if tmp == "test_level.tscn":
					continue
				lvl_count += 1
				var tmpPath = dir.get_current_dir() + "/" + tmp
				var tmpName = "Level " + str(lvl_count)
				create_button(tmpPath,tmpName)
				level_names.append(tmp)
			else:
				dir.list_dir_end()
				break
				
	for name in level_names:
		print(name)

func create_button(lvl_path, lvl_name):
	var btn = LEVEL_BUTTON.instantiate()
	btn.level_path = lvl_path
	btn.text = lvl_name
	container.add_child(btn)
