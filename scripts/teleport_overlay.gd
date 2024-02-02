class_name TeleportOverlay extends Control

const SCROLL_SPEED = 10

@onready var panel = $Panel

func _ready():
	Global.register(self)

func activate():
	visible = true

func _process(delta):
	if visible:
		panel.position.x += SCROLL_SPEED * delta
		if panel.position.x > get_viewport().get_visible_rect().size:
			panel.position.x = 0
			visible = false
