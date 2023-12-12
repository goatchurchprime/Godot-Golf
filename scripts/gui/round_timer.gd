class_name RoundTimer extends Control

@onready var time_label = $TimeLabel
@onready var timer = $Timer

signal timeout

func _process(delta):
	if not timer.is_stopped():
		time_label.text = str(floor(timer.time_left))

func start_timer():
	timer.start()

func stop_timer():
	timer.stop()

func _on_timer_timeout():
	timeout.emit()
