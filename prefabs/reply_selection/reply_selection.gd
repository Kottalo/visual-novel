@tool
class_name ReplySelection
extends PanelContainer

signal reply_clicked(text: String, next_id: String)

@export var reply_text: RichTextLabel

@export var hover_shade: Control
@export var select_shade: Control
@export var hovered: bool:
	set(value):
		hovered = value
		hover_shade.visible = hovered
		_update_text_color()
@export var selected: bool:
	set(value):
		selected = value
		select_shade.visible = selected
		_update_text_color()

var next_id: String

func _ready() -> void:
	_update_text_color()
	mouse_entered.connect(
		func (): hovered = true
	)
	mouse_exited.connect(
		func (): hovered = false
	)
	gui_input.connect(
		func (event: InputEvent):
			if event is InputEventMouseButton:
				if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					reply_clicked.emit(reply_text.text, next_id)
	)

func setup(text: String, _next_id: String) -> void:
	reply_text.text = text
	_update_text_color()
	next_id = _next_id

func _update_text_color() -> void:
	reply_text.modulate = Color.WHITE if selected or hovered else Color.BLACK
