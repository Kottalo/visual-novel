class_name LocationPage
extends Control

@export var place_textures: Array[Texture2D]
@export var vbox_selections: VBoxContainer
@export var place_selection: Control

@onready var original_y: float = vbox_selections.global_position.y

var slide_tolerance: float = 200
var slide_duration: float = 0.8
var start_y: float

var selected_index: int:
	set(value):
		var last_index = selected_index
		selected_index = value
		
		var index_difference = last_index - selected_index
		var target_y = original_y + (place_selection.size.y * index_difference)
		await create_tween().tween_property(
			vbox_selections, "position:y",
			target_y,
			slide_duration
		).finished
		
		update()

var button_pressed: bool:
	set(value):
		button_pressed = value

func _ready() -> void:
	vbox_selections.gui_input.connect(
		func (event: InputEvent):
			if event is InputEventMouseButton:
				if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
					button_pressed = true
					start_y = event.global_position.y
	)
	update()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if button_pressed:
			if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
				button_pressed = false
				create_tween().tween_property(vbox_selections, "position:y", original_y, 0.3)
	
	var y_difference: float
	if button_pressed:
		if event is InputEventMouseMotion:
			y_difference = event.global_position.y - start_y
			y_difference = clamp(y_difference, -slide_tolerance, slide_tolerance)
			vbox_selections.global_position.y = original_y + y_difference
	if y_difference >= slide_tolerance:
		selected_index -= 1
		button_pressed = false
	if y_difference <= -slide_tolerance:
		selected_index += 1
		button_pressed = false
	
	#if event is Mouse

func update() -> void:
	for selection: PlaceSelection in vbox_selections.get_children():
		var offset_index = selection.get_index() - 2
		var target_index = selected_index + offset_index
		target_index %= place_textures.size()
		selection.texture_rect_image.texture = place_textures[target_index]
	vbox_selections.global_position.y = original_y
