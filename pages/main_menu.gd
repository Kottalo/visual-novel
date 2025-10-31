class_name MainMenu
extends Control

@export var button_start: MainMenuButton
@export var button_load: MainMenuButton
@export var button_bonus: MainMenuButton
@export var button_book: MainMenuButton
@export var button_setting: MainMenuButton
@export var button_quit: MainMenuButton

func _ready() -> void:
	Pages.main_menu = self

	button_start.clicked.connect(
		func ():
			Stage.start()
	)
	button_load.clicked.connect(
		func ():
			Pages.profile.profile_mode = ProfilePage.ProfileMode.LOAD
			Pages.current_page = Pages.profile
	)
	button_bonus.clicked.connect(
		func ():
			Pages.current_page = Pages.bonus
	)
	button_book.clicked.connect(
		func ():
			Pages.current_page = Pages.book
	)
	button_setting.clicked.connect(
		func (): pass
	)
	button_quit.clicked.connect(
		func (): get_tree().quit()
	)
