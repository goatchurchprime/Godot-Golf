class_name HUD extends CanvasLayer

@onready var score_label = $Control/PanelContainer/Panel/ScoreLabel

func update_text(puts):
	score_label.text = str(puts)
