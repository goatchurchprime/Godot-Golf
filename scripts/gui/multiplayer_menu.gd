class_name MultiplayerMenu extends Control

@export var player_scene : PackedScene

@onready var name_line_edit = $NameSelectionContainer/NameLineEdit
@onready var ip_line_edit = $MultiplayerContainer/IPLineEdit

@onready var name_selection_container = $NameSelectionContainer
@onready var singleplayer_multiplayer_container = $SingleplayerMultiplayerContainer
@onready var multiplayer_container = $MultiplayerContainer

var username : String

const PORT = 1984
const MAX_PLAYERS = 8

var enet_peer = ENetMultiplayerPeer.new()
var peer = ENetMultiplayerPeer.new()

signal player_added

func _on_host_pressed():
	Global.set_multiplayer()
	hide()
	enet_peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(player_disconnected)
	add_player(multiplayer.get_unique_id())

func _on_join_pressed():
	hide()
	enet_peer.create_client(ip_line_edit.text if ip_line_edit.text else "127.0.0.1", PORT)
	multiplayer.multiplayer_peer = enet_peer
	add_player(multiplayer.get_unique_id())
	Global.set_multiplayer()

func add_player(peer_id):
	print("Player connected")
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	player.username = username
	get_tree().current_scene.add_child(player)
	Global.register(player)

@rpc("authority")
func player_disconnected(peer_id):
	for player in get_tree().get_nodes_in_group("players"):
		if player.get_multiplayer_authority() == peer_id:
			player.queue_free()

func _on_singleplayer_button_pressed():
	# Host authority defaults to 1, but opens no server
	add_player(1)
	Global.set_singleplayer()
	queue_free()

func _on_multiplayer_button_pressed():
	singleplayer_multiplayer_container.queue_free()
	multiplayer_container.visible = true

func _on_name_confirm_button_pressed():
	username = str(name_line_edit.text)
	name_selection_container.queue_free()
	name_selection_container = null
	singleplayer_multiplayer_container.visible = true

func _on_web_rtc_pressed():
	$NetworkGateway.PlayerConnections.LocalPlayer.get_node("Label").text = username
	var roomname = singleplayer_multiplayer_container.get_node("HBoxWebRTC/LineEdit").text
	if roomname:
		$NetworkGateway.MQTTsignalling.get_node("VBox/HBox2/roomname").text = roomname
		$NetworkGateway.selectandtrigger_networkoption($NetworkGateway.NETWORK_OPTIONS_MQTT_WEBRTC.AS_NECESSARY_MANUALCHANGE)
		singleplayer_multiplayer_container.queue_free()
		singleplayer_multiplayer_container = null


func _on_network_gateway_resolved_as_necessary(asserver):
	print("_on_network_gateway_resolved_as_necessary ", asserver)
	if asserver:
		Global.set_multiplayer()
		hide()
		$NetworkGateway.selectandtrigger_networkoption($NetworkGateway.NETWORK_OPTIONS_MQTT_WEBRTC.AS_SERVER)
	else:
		hide()
		$NetworkGateway.selectandtrigger_networkoption($NetworkGateway.NETWORK_OPTIONS_MQTT_WEBRTC.AS_CLIENT)


func _on_network_gateway_webrtc_multiplayerpeer_set(asserver):
	print("_on_network_gateway_webrtc_multiplayerpeer_set ", asserver)
	if asserver:
		print("** server ",multiplayer.multiplayer_peer, multiplayer.is_server())
		multiplayer.peer_connected.connect(add_player)
		multiplayer.peer_disconnected.connect(player_disconnected)
		add_player(multiplayer.get_unique_id())
	else:
		print("** client ",multiplayer.multiplayer_peer, multiplayer.is_server())
		add_player(multiplayer.get_unique_id())
		Global.set_multiplayer()
