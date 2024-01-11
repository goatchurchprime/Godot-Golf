class_name GameStatus extends Control

enum statuses {PEER_CONNECTED, CONNECTION_SUCCESFUL, CONNECTION_FAILED, HOST_CHOOSING_MAP, DISCONNECTED, HIDDEN}

@onready var label = $CenterContainer/Label

func set_status(status):
	var message : String
	match status:
		statuses.PEER_CONNECTED:
			message = "A peer has connected"
		statuses.CONNECTION_SUCCESFUL:
			message = "Connection Succesful"
		statuses.CONNECTION_FAILED:
			message = "Connection failed"
		statuses.HOST_CHOOSING_MAP:
			message = "The host is currently choosing a map"
		statuses.DISCONNECTED:
			message = "The host has disconnected"
		statuses.HIDDEN:
			message = ""
	label.text = message
