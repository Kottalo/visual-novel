class_name StagePage
extends CanvasLayer
## A basic dialogue balloon for use with Dialogue Manager.

@export var autoplay_pause_time: float = 1
@export var normal_step_rate: float = 0.02
@export var skip_step_rate: float = 0.01
@export var auto_step_rate: float = 0.1

@export var dialogue_screen: Control
@export var responses_menu: DialogueResponsesMenu
@export var subviewport: SubViewport
@export var hbox_positions: HBoxContainer
@export var character_image_pool: Control
@export var texture_rect_background: TextureRect
@export var texture_rect_blackscreen: ColorRect

@export var bg_common: TextureRect
@export var bg_character: TextureRect
@export var avatar: TextureRect

var skip: bool = false:
	set(value):
		skip = value
		update_step_rate()

var autoplay: bool = false:
	set(value):
		autoplay = value
		update_step_rate()

func update_step_rate() -> void:
	var rate = auto_step_rate if autoplay else normal_step_rate
	rate = skip_step_rate if skip else rate
	
	#dialogue_label.seconds_per_step = rate
	
	if is_waiting_for_input:
		if autoplay or skip:
			Game.stage_page.go_next()

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_dialogue_screen: bool = false

## A dictionary to store any ephemeral variables
var locals: Dictionary = {}

var _locale: String = TranslationServer.get_locale()

func get_position_by_name(position_name: String) -> Vector2:
	var position_node: Control = hbox_positions.get_node(position_name + "/CenterPoint")
	
	return position_node.global_position

## The current line
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
