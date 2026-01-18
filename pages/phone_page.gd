class_name PhonePage
extends CanvasLayer

@export var dialogue: DialogueResource

@export var phone_background: Texture2D
@export var chat_background: Texture2D

@export var background: Control
@export var phone_icon_message: PhoneIcon
@export var phone_icon_photo: PhoneIcon
@export var phone_icon_music: PhoneIcon
@export var phone_icon_book: PhoneIcon

@export var message_text_pool: Control
@export var reply_selection_pool: Control

var dialogue_line: DialogueLine:
	set(value):
		dialogue_line = value
		
		if not dialogue_line: return
		
		var chat_message: ChatMessage = Prefabs.chat_message.instantiate()
		match dialogue_line.character:
			"Self":
				chat_message.sender_type = Enums.SenderType.SELF
			"Other":
				chat_message.sender_type = Enums.SenderType.OTHER
		chat_message.message_text.text = dialogue_line.text
		if dialogue_line.responses:
			for response: DialogueResponse in dialogue_line.responses:
				var reply_selection: ReplySelection = Prefabs.reply_selection.instantiate()
				reply_selection.reply_text.text = response.text
			return
		
		dialogue_line = await dialogue.get_next_dialogue_line(dialogue_line.next_id)

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
	
	dialogue_line = await dialogue.get_next_dialogue_line("start")
	
