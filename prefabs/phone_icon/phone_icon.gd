@tool
class_name PhoneIcon
extends PanelContainer

signal clicked

@export var icon: Texture2D:
	set(value):
		icon = value
		texture_rect_icon.texture = icon
@export var texture_rect_icon: TextureRect
@export var title: String:
	set(value):
		title = value
		label_title.text = title
@export var label_title: Label

var color_normal = Color(1.0, 1.0, 1.0)
var color_hover = Color(0.7, 0.7, 0.7)
var color_click = Color(0.5, 0.5, 0.5)

var click: bool
var hover: bool

func update() -> void:
	if click:
		texture_rect_icon.modulate = color_click
		self_modulate.a = 1
	else:
		texture_rect_icon.modulate = color_hover if hover else color_normal
		self_modulate.a = 0

func _ready() -> void:
	texture_rect_icon.mouse_entered.connect(
		func ():
			hover = true
			update()
	)
	texture_rect_icon.mouse_exited.connect(
		func ():
			hover = false
			update()
	)
	texture_rect_icon.gui_input.connect(
		func (event: InputEvent):
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.is_pressed():
						click = true
						update()
						clicked.emit()
					if event.is_released():
						click = false
						update()
	)
	update()
