extends Button

@export_file("*.tscn") var level_path

func _on_pressed():
	get_tree().change_scene_to_file(level_path)
