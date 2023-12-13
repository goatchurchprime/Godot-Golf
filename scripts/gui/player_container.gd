class_name PlayerContainer extends HBoxContainer

var id

@onready var name_label = $Name
@onready var score_label = $Score

func set_username(name):
	name_label.text = name

func set_score(score):
	print("score")
	score_label.text = str(score)

func get_username():
	return str(name_label.text)
