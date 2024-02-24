class_name TeleportOverlay extends Control

@onready var animation_player = $AnimationPlayer

func _ready():
	Global.register(self)

func activate():
	visible = true
	animation_player.play("slide_away")

func _on_animation_player_animation_finished(anim_name):
	visible = false
