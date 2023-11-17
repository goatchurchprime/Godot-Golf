class_name Leaderboard extends Control

@onready var high_scores_label = $VBoxContainer/HighscoresLabel


func set_highscores(scores_dict):
	var text = ""
	for score in scores_dict:
		text += score + ": " + str(scores_dict[score]) + "\n"
	high_scores_label.text = text
