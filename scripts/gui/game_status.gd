class_name GameStatus extends Control

enum statuses {PEER_CONNECTED, CONNECTION_SUCCESSFUL, CONNECTION_FAILED, HOST_CHOOSING_MAP, DISCONNECTED, HIDDEN}

@onready var label = $CenterContainer/Label

func _ready():
	Global.register(self)
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.connected_to_server.connect(connection_successful)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected .connect(server_disconnected)

func peer_connected(_peer_id):
	if multiplayer.is_server():
		set_status(statuses.PEER_CONNECTED)

func connection_successful():
	set_status(statuses.CONNECTION_SUCCESSFUL)

func connection_failed():
	set_status(statuses.CONNECTION_FAILED)

func server_disconnected():
	set_status(statuses.DISCONNECTED)

func set_status(status):
	var message : String
	match status:
		statuses.PEER_CONNECTED:
			message = "A peer has connected"
		statuses.CONNECTION_SUCCESSFUL:
			message = "Connection Successful"
		statuses.CONNECTION_FAILED:
			message = "Connection failed"
		statuses.HOST_CHOOSING_MAP:
			message = "The host is currently choosing a map"
		statuses.DISCONNECTED:
			message = "The host has disconnected"
		statuses.HIDDEN:
			message = ""
	label.text = message
