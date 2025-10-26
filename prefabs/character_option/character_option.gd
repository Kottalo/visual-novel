class_name CharacterOption
extends HBoxContainer

@export var body_part: String
@export var label: Label
@export var previous_button: TextureButton
@export var next_button: TextureButton
@export var label_option_name: Label

var option_list: Array

signal option_index_changed
var option_index: int:
	set(value):
		option_index = value
		if option_index < 0: option_index = option_list.size() - 1
		if option_index >= option_list.size(): option_index = 0
		label_option_name.text = option_name
		option_index_changed.emit()

var option_name: String:
	get:
		if option_list.size() == 0: return ""
		return option_list[option_index]

func _ready() -> void:
	previous_button.pressed.connect(
		func (): option_index -= 1
	)
	next_button.pressed.connect(
		func (): option_index += 1
	)
