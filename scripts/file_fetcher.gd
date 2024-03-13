class_name FileFetcher extends Node

static func get_scenes_in_path(path):
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

static func get_sounds_in_path(path):
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

# Fixes resource loading when game is exported. Trims suffixes remap and import
static func trim_suffixes(file_path):
	file_path = file_path.trim_suffix(".remap")
	file_path = file_path.trim_suffix(".import")
	return file_path
