class_name FileFetcher extends Node

func get_scenes_in_path(path):
	var arr = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				var file_path = dir.get_current_dir() + "/" + tmp
				file_path = trim_suffixes(file_path)
				arr.append(file_path)
			else:
				dir.list_dir_end()
				break
	return arr

func get_sounds_in_path(path):
	var arr = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				var file_path = dir.get_current_dir() + "/" + tmp
				file_path = trim_suffixes(file_path)
				arr.append(ResourceLoader.load(file_path))
			else:
				dir.list_dir_end()
				break
	return arr
