class_name RoundTimerUI extends Control

@onready var time_label = $HBoxContainer/TimeLabel
@onready var timer = $Timer

signal timeout

func _process(delta):
	if not timer.is_stopped():
		time_label.text = str(floor(timer.time_left))

func start():
	timer.start()

func stop():
	timer.stop()

func _on_timer_timeout():
	timeout.emit()
