@tool
extends "res://addons/dialogic/Modules/LayeredPortrait/layered_portrait.gd"

enum PortraitMode { Main, Avatar }

@export var portrait_mode: PortraitMode = PortraitMode.Main:
	set(value):
		portrait_mode = value
		update()
@export var main: Sprite2D
@export var avatar: Sprite2D
@export var parts: Array[Node2D]

func _ready() -> void:
	update()

func update() -> void:
	for part in parts:
		for item: Sprite2D in part.get_children():
			item.region_enabled = true
			item.region_rect = main.region_rect if portrait_mode == PortraitMode.Main \
			else avatar.region_rect
