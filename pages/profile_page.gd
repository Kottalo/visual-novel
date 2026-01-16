class_name ProfilePage
extends CanvasLayer

@export var profile_card_model: ProfileCard
@export var title_load: TextureRect
@export var title_save: TextureRect
@export var profile_card_pool: GridContainer

func _ready() -> void:	
	visibility_changed.connect(
		func ():
			title_load.visible = Main.profile_mode == Main.ProfileMode.LOAD
			title_save.visible = Main.profile_mode == Main.ProfileMode.SAVE
			if visible:
				update()
	)

func update() -> void:
	Main.clear_children(profile_card_pool)
	for profile in Main.save_data.profiles:
		var profile_card: ProfileCard = profile_card_model.duplicate()
		profile_card.texture_rect_preview.texture = profile.preview
		profile_card_pool.add_child(profile_card)
		profile_card.label_index.text = "NO.%02d" % [profile_card.get_index() + 1]
	if Main.profile_mode == Main.ProfileMode.SAVE:
		profile_card_pool.add_child(profile_card_model.duplicate())
