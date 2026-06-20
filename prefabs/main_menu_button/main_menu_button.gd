class_name MainMenuButton
extends Control

signal clicked
signal continue_requested

@export var texture_hover: TextureRect
@export var texture_click: TextureRect
@export var click_box: Control
@export var label_chinese: Label
@export var label_english: Label

const LONG_PRESS_SECONDS: float = 0.45

var selected: bool = false
var _left_press_started_at: float = -1.0

func _ready() -> void:
	click_box.mouse_entered.connect(
		func ():
			texture_hover.visible = true
	)
	click_box.mouse_exited.connect(
		func ():
			texture_hover.visible = false
			texture_click.visible = false
			_left_press_started_at = -1.0
	)

	click_box.gui_input.connect(_on_click_box_gui_input)

func _on_click_box_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_left_press_started_at = Time.get_ticks_msec() / 1000.0
			texture_click.visible = true
			return
		if event.is_released():
			texture_click.visible = false
			var press_duration := 0.0
			if _left_press_started_at >= 0.0:
				press_duration = Time.get_ticks_msec() / 1000.0 - _left_press_started_at
			_left_press_started_at = -1.0
			if press_duration >= LONG_PRESS_SECONDS:
				continue_requested.emit()
			else:
				clicked.emit()
			return
	if event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			texture_click.visible = true
			return
		if event.is_released():
			texture_click.visible = false
			continue_requested.emit()

func set_titles(chinese: String, english: String) -> void:
	label_chinese.text = chinese
	label_english.text = english
