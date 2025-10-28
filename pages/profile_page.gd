class_name ProfilePage
extends Control

enum ProfileMode { LOAD, SAVE }

@export var title_load: TextureRect
@export var title_save: TextureRect

var profile_mode: ProfileMode:
	set(value):
		profile_mode = value
		title_load.visible = profile_mode == ProfileMode.LOAD
		title_save.visible = profile_mode == ProfileMode.SAVE

func _ready() -> void:
	Pages.profile = self
