class_name PuttingUI extends Control

@onready var score_label = $Panel/HorseHUD/ScoreLabel

func update_text(puts):
	score_label.text = str(puts)
