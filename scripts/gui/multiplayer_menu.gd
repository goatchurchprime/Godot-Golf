class_name MultiplayerMenu extends Control

@export var player_scene : PackedScene

@onready var singleplayer_multiplayer_container = $SingleplayerMultiplayerContainer
@onready var multiplayer_container = $MultiplayerContainer
@onready var ip_line_edit = $MultiplayerContainer/IPLineEdit

var players : Array

const PORT = 1984
const MAX_PLAYERS = 8

var enet_peer = ENetMultiplayerPeer.new()
var peer = ENetMultiplayerPeer.new()

signal is_multiplayer
signal is_singleplayer

func _on_host_pressed():
	hide()
	enet_peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(player_disconnected)
	add_player(multiplayer.get_unique_id())
	is_multiplayer.emit(true)

func _on_join_pressed():
	hide()
	enet_peer.create_client(ip_line_edit.text, PORT)
	multiplayer.multiplayer_peer = enet_peer
	is_multiplayer.emit(false)

func add_player(peer_id):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	get_tree().current_scene.add_child(player)
	players.append(player)

func player_disconnected(peer_id):
	for player in players:
		if player.get_multiplayer_authority() == peer_id:
			players.erase(player)
			player.queue_free()

func _on_singleplayer_button_pressed():
	is_singleplayer.emit()
	# Host authority defaults to 1, but opens no server
	add_player(1)

func _on_multiplayer_button_pressed():
	singleplayer_multiplayer_container.queue_free()
	multiplayer_container.visible = true
