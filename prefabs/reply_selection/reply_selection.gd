@tool
class_name ReplySelection
extends PanelContainer

@export var reply_text: RichTextLabel

@export var hover_shade: Control
@export var select_shade: Control
@export var hovered: bool:
	set(value):
		hovered = value
		hover_shade.visible = hovered
@export var selected: bool:
	set(value):
		selected = value
		select_shade.visible = selected

func _ready() -> void:
	mouse_entered.connect(
		func (): hovered = true
	)
	mouse_exited.connect(
		func (): hovered = false
	)
