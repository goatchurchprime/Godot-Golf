class_name SpawnLocation extends Node3D

@onready var arrow = $MeshInstance3D

func _ready():
	remove_child(arrow)
	arrow.queue_free()
	arrow = null

func get_global_pos():
	return self.global_position
