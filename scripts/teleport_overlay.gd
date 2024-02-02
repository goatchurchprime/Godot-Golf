class_name TeleportOverlay extends Control

const SCROLL_SPEED = 2

@onready var panel = $Panel

func _ready():
	Global.register(self)

func activate():
	visible = true

func _process(delta):
	if visible:
		panel.position.x += SCROLL_SPEED * delta * get_viewport().get_visible_rect().size.x
		if panel.position.x > get_viewport().get_visible_rect().size.x:
			panel.position.x = 0
			visible = false
