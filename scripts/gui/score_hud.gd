class_name HUD extends Control

@onready var score_label = $PanelContainer/Panel/ScoreLabel

func update_text(puts):
	score_label.text = str(puts)
