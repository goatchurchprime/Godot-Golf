class_name MultiplayerMenu extends Control

@export var player_scene : PackedScene

var players : Array

const PORT = 1984
const MAX_PLAYERS = 8

var enet_peer = ENetMultiplayerPeer.new()

var peer = ENetMultiplayerPeer.new()

func _on_host_pressed():
	hide()
	enet_peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(player_disconnected)
	add_player(multiplayer.get_unique_id())

func _on_join_pressed():
	hide()	
	enet_peer.create_client("127.0.0.1", PORT)
	multiplayer.multiplayer_peer = enet_peer

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
