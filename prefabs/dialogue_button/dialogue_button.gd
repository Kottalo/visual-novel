class_name DialogueButton
extends TextureRect

@export var toggle_button: bool
@export var select_frame: TextureRect
@export var icon: TextureRect
@export var click_rect: Control

@export var toggled: bool:
	set(value):
		toggled = value
		
		select_frame.visible = toggle_button and toggled

func _ready() -> void:
	icon.mouse_entered.connect(
		func ():
			var c_val = 0.5
			icon.modulate = Color(c_val, c_val, c_val)
	)
	icon.mouse_exited.connect(
		func ():
			var c_val = 1
			icon.modulate = Color(c_val, c_val, c_val)
	)
	
	
	toggled = toggled
