@tool
class_name SelectionButton
extends PanelContainer

@export var title: String:
	set(value):
		title = value
		label_title.text = title

@export var selected: bool:
	set(value):
		selected = value
		select_rect.visible = selected

@export var hovered: bool:
	set(value):
		hovered = value
		hover_rect.visible = hovered

@export var select_rect: ColorRect
@export var hover_rect: ColorRect
@export var label_title: Label
