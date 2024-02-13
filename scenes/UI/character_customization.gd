class_name CharacterCustomization extends Control

@onready var color_preview = $MarginContainer/VBoxContainer/ColorPreview

@onready var red_slider = $MarginContainer/VBoxContainer/Red
@onready var green_slider = $MarginContainer/VBoxContainer/Green
@onready var blue_slider = $MarginContainer/VBoxContainer/Blue

func _ready():
	Global.register(self)

func _on_red_value_changed(value):
	set_color_preview()

func _on_green_value_changed(value):
	set_color_preview()

func _on_blue_value_changed(value):
	set_color_preview()

func set_color_preview():
	var r = red_slider.value / 255
	var g = green_slider.value / 255
	var b = blue_slider.value / 255
	color_preview.color = Color(r,g,b)
