class_name CharacterOption
extends HBoxContainer

@export var body_part: String
@export var label: Label
@export var previous_button: TextureButton
@export var next_button: TextureButton
@export var label_option_name: Label

var option_name: String:
	set(value):
		option_name = value
		label_option_name.text = option_name
