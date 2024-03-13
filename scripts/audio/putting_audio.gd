class_name PuttingAudio extends AudioStreamPlayer3D

@onready var golfball = $"../.."

func _on_golfball_putted():
	volume_db = golfball.get_hit_strength() - golfball.MAX_STRENGTH * 1.5
	volume_db = min(volume_db, 0)
	play()
