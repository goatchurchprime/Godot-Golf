class_name Scoreboard extends Control

const player_container_scene = preload("res://scenes/UI/scoreboard_elements/player_container.tscn")

@onready var container = $Panel/MarginContainer/VBoxContainer

var player_container_dict = {}

func _ready():
	Global.register(self)

func _unhandled_input(event):
	if event.is_action_pressed("scoreboard"):
		visible = true
	elif event.is_action_released("scoreboard"):
		visible = false

func next_hole():
	for player in player_container_dict:
		player_container_dict[player].next_hole()

func update():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		if player_container_dict.has(player.name):
			player_container_dict[player.name].set_score(player.putts)
		else:
			add_new_player(player)

func add_new_player(player):
	var tmp = player_container_scene.instantiate()
	player_container_dict[player.name] = tmp
	container.add_child(tmp)
	tmp.set_username(player.username)

func reset():
	for player in player_container_dict:
		container.remove_child(player_container_dict[player])
	player_container_dict.clear()
