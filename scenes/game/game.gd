class_name Game
extends Control

@export var page_container: Control
@export var layer_stage_pages: CanvasLayer
@export var stage_page_container: Control

@export var button_start: MainMenuButton
@export var button_load: MainMenuButton
@export var button_bonus: MainMenuButton
@export var button_book: MainMenuButton
@export var button_setting: MainMenuButton
@export var button_quit: MainMenuButton

func _ready() -> void:
	button_start.clicked.connect(
		func (): Stage.start()
	)
	button_load.clicked.connect(
		func ():
			Pages.profile.profile_mode = ProfilePage.ProfileMode.LOAD
			Pages.profile.show()
	)
	button_bonus.clicked.connect(
		func (): Pages.bonus.show()
	)
	button_book.clicked.connect(
		func (): Pages.book.show()
	)
	button_setting.clicked.connect(
		func (): pass
	)
	button_quit.clicked.connect(
		func (): get_tree().quit()
	)

	for page: Control in stage_page_container.get_children():
		page.visibility_changed.connect(
			func ():
				layer_stage_pages.visible = page.visible
		)

func switch_page(page_name: String) -> void:
	for page: Control in page_container.get_children():
		page.visible = page.name == page_name
