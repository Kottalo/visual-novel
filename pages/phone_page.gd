class_name PhonePage
extends CanvasLayer

@export var background: Control
@export var phone_icon_message: PhoneIcon
@export var phone_icon_photo: PhoneIcon
@export var phone_icon_music: PhoneIcon
@export var phone_icon_book: PhoneIcon

func _ready() -> void:
	background.gui_input.connect(
		func (event: InputEvent):
			if event is InputEventMouseButton:
				if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					hide()
	)
	
	phone_icon_photo.clicked.connect(
		func ():
			Game.bonus_page.show()
			Game.bonus_page.layer = 2
			Main.bonus_tab_index = 1
	)
	
	phone_icon_music.clicked.connect(
		func ():
			Game.bonus_page.show()
			Game.bonus_page.layer = 2
			Main.bonus_tab_index = 2
	)
