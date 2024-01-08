class_name PlayerContainer extends HBoxContainer

@onready var name_label = $Name
var score_label

func next_hole():
	var tmp = Label.new()
	tmp.text = str(0)
	add_child(tmp)
	score_label = tmp

func set_username(name):
	name_label.text = name

func set_score(score):
	if score_label:
		score_label.text = str(score)

func get_username():
	return str(name_label.text)
