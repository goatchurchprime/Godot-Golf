class_name HUD extends CanvasLayer

@onready var score_label = $Control/PanelContainer/Panel/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_text(puts):
	score_label.text = str(puts)
