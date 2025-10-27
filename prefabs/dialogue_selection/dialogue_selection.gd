class_name DialogueSelection
extends TextureButton

@export var label_text: Label

var text: String:
	set(value):
		text = value
		label_text.text = text
