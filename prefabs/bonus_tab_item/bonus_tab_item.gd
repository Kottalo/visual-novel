class_name BonusTabItem
extends TextureRect

@export var target_tab: Control
@export var selected_frame: TextureRect
@export var hover_hint: TextureRect

var selected: bool:
	get:
		return Main.bonus_tab_index == get_index()

var hovered: bool:
	set(value):
		hovered = value
		hover_hint.visible = hovered

func _ready() -> void:
	Main.bonus_tab_index_changed.connect(update)
	mouse_entered.connect(
		func (): hovered = true
	)
	mouse_entered.connect(
		func (): hovered = false
	)
	
	hovered = false
	update()

func update() -> void:
	target_tab.visible = selected
	selected_frame.visible = selected
