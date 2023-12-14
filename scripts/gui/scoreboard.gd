class_name Scoreboard extends Control

const player_container_scene = preload("res://scenes/UI/scoreboard_elements/player_container.tscn")

@onready var container = $Panel/MarginContainer/VBoxContainer

var player_dict = {}

func _unhandled_input(event):
	if event.is_action_pressed("scoreboard"):
		visible = true
	elif event.is_action_released("scoreboard"):
		visible = false

func update():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		if player_dict.has(player.name):
			player_dict[player.name].set_score(player.putts)
		else:
			add_new_player(player)

func add_new_player(player):
	var tmp = player_container_scene.instantiate()
	player_dict[player.name] = tmp
	container.add_child(tmp)
	tmp.set_username(player.username)
