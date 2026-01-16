extends Node

@export var button_skip: DialogueButton
@export var button_auto: DialogueButton
@export var button_save: DialogueButton
@export var button_load: DialogueButton
@export var button_log: DialogueButton
@export var button_set: DialogueButton
@export var button_phone: DialogueButton
@export var button_book: DialogueButton
@export var button_title: DialogueButton

func _ready() -> void:
	button_skip.toggle_changed.connect(
		func ():
			pass
	)
	button_auto.toggle_changed.connect(
		func ():
			pass
	)
	button_save.clicked.connect(
		func ():
			Main.profile_mode = Main.ProfileMode.SAVE
			Pages.profile.show()
	)
	button_load.clicked.connect(
		func ():
			Main.profile_mode = Main.ProfileMode.LOAD
			Pages.profile.show()
	)
	button_log.clicked.connect(
		func (): Pages.log.show()
	)
	button_set.clicked.connect(
		func ():
			pass
	)
	button_phone.clicked.connect(
		func (): Pages.phone.show()
	)
	button_book.clicked.connect(
		func (): Pages.book.show()
	)
	button_title.clicked.connect(
		func ():
			pass
	)
