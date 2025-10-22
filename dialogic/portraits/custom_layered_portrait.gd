@tool
extends "res://addons/dialogic/Modules/LayeredPortrait/layered_portrait.gd"

@export var main: Sprite2D
@export var parts: Array[Node2D]

func _ready() -> void:
	for part in parts:
		for item: Sprite2D in part.get_children():
			item.region_enabled = true
			item.region_rect = main.region_rect
