class_name FileFetcher extends Node

func get_sounds_in_path(path):
	var arr = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				var file_path = dir.get_current_dir() + "/" + tmp
				# Fixes exporting audio, removes suffix .remap and .import
				file_path = file_path.trim_suffix(".remap")
				file_path = file_path.trim_suffix(".import")
				arr.append(ResourceLoader.load(file_path))
			else:
				dir.list_dir_end()
				break
	print(arr)
	return arr
