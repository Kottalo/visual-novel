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
			hide()
			Main.game.switch_page("BonusPage")
	)
