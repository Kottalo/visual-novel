class_name MainMenu
extends CanvasLayer

@export var button_start: MainMenuButton
@export var button_load: MainMenuButton
@export var button_bonus: MainMenuButton
@export var button_book: MainMenuButton
@export var button_setting: MainMenuButton
@export var button_quit: MainMenuButton

func _ready() -> void:
	button_start.clicked.connect(
		func ():
			Stage.start()
	)
	button_load.clicked.connect(
		func ():
			Main.profile_mode = Main.ProfileMode.LOAD
			hide()
			Game.profile_page.show()
	)
	button_bonus.clicked.connect(
		func ():
			hide()
			Game.bonus_page.show()
	)
	button_book.clicked.connect(
		func (): Game.book_page.show()
	)
	button_setting.clicked.connect(
		func (): Game.setting_page.show()
	)
	button_quit.clicked.connect(
		func (): get_tree().quit()
	)
