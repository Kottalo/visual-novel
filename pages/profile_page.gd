class_name ProfilePage
extends Control

@export var profile_card: SaveProfileCard
@export var title_load: TextureRect
@export var title_save: TextureRect

func _ready() -> void:
	Pages.profile = self
	
	visibility_changed.connect(
		func ():
			title_load.visible = Main.profile_mode == Main.ProfileMode.LOAD
			title_save.visible = Main.profile_mode == Main.ProfileMode.SAVE
	)
