class_name LogLine
extends MarginContainer

@export var vbox_character_info: VBoxContainer
@export var label_character_name: Label
@export var rich_label_dialogue_text: RichTextLabel

var character_name: String:
	set(value):
		character_name = value
		label_character_name.text = character_name
		vbox_character_info.modulate.a = 1 if character_name else 0

var dialogue_text: String:
	set(value):
		dialogue_text = value
		rich_label_dialogue_text.text = dialogue_text
