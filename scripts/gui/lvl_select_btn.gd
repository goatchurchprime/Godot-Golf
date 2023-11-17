extends Button

signal change_level

@export_file("*.tscn") var level_path

func _on_pressed():
	emit_signal("change_level", level_path, text)
