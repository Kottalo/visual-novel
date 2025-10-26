class_name CharacterSelection
extends TextureRect

@export var texture_rect_frame: TextureRect
@export var color_hovered: Color
@export var color_selected: Color
@export var selection_frame: Control

var selected: bool:
	get:
		return Main.character_selection_index == get_index()

var hovered: bool:
	set(value):
		hovered = value
		update()
		

func _ready() -> void:
	selection_frame.mouse_entered.connect(
		func (): hovered = true
	)
	selection_frame.mouse_exited.connect(
		func (): hovered = false
	)
	selection_frame.gui_input.connect(
		func (event: InputEvent):
			if event is InputEventMouseButton:
				if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
					Main.character_selection_index = get_index()
	)
	Main.character_selection_index_changed.connect(update)
	
	update()

func update() -> void:
	texture_rect_frame.visible = selected
	modulate = color_hovered if hovered else color_selected
