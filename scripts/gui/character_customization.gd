class_name CharacterCustomization extends Control

@onready var customize_button = $CharacterCustomizeButton
@onready var customization_container = $CustomizationContainer

@onready var color_preview = $CustomizationContainer/VBoxContainer/ColorPreview

@onready var red_slider = $CustomizationContainer/VBoxContainer/Red
@onready var green_slider = $CustomizationContainer/VBoxContainer/Green
@onready var blue_slider = $CustomizationContainer/VBoxContainer/Blue

func _ready():
	Global.register(self)
	set_status(false)

func _on_red_value_changed(value):
	set_color_preview()

func _on_green_value_changed(value):
	set_color_preview()

func _on_blue_value_changed(value):
	set_color_preview()

func set_color_preview():
	var r = red_slider.value
	var g = green_slider.value
	var b = blue_slider.value
	color_preview.color = Color(r,g,b)

func _on_exit_pressed():
	set_status(false)

func _on_apply_pressed():
	var r = red_slider.value
	var g = green_slider.value
	var b = blue_slider.value
	Global.set_player_color(Color(r,g,b))

func _on_character_customize_button_pressed():
	set_status(true)

func set_status(status):
	if status:
		add_child(customization_container)
		remove_child(customize_button)
	else:
		remove_child(customization_container)
		add_child(customize_button)
