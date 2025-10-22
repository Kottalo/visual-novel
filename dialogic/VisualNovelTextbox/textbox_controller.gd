extends Node

@export var sizer: Control
@export var textbox_layer: Control

func _ready() -> void:
	sizer.position = Vector2()
	sizer.size = textbox_layer.size
