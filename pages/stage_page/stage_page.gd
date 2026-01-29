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
@export var character_image_pool: Node2D
@export var texture_rect_background: TextureRect
@export var texture_rect_blackscreen: ColorRect

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

## A sound player for voice lines (if they exist).
#@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

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
	
	dialogue_label.seconds_per_step = rate
	
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
			
			apply_dialogue_line()
		else:
			# The dialogue has finished so close the balloon
			for character in character_image_pool.get_children():
				character_image_pool.remove_child(character)
				character.queue_free()
			hide()
			Game.main_menu.show()
	get:
		return dialogue_line

## A cooldown timer for delaying the balloon hide when encountering a mutation.
var mutation_cooldown: Timer = Timer.new()

## The label showing the name of the currently speaking character
@export var character_label: RichTextLabel

## The label showing the currently spoken dialogue
@export var dialogue_label: DialogueLabel

## Indicator to show that player can progress dialogue.
@export var progress: Polygon2D


func _ready() -> void:
	dialogue_screen.modulate.a = 0
	
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action

	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)
	
	dialogue_screen.gui_input.connect(_on_dialogue_screen_gui_input)
	responses_menu.response_selected.connect(_on_responses_menu_response_selected)


func _process(_delta: float) -> void:
	if not dialogue_line: return
	
	progress.visible = not dialogue_label.is_typing and dialogue_line.responses.size() == 0 and not dialogue_line.has_tag("voice")
	
	responses_menu.visible = responses_menu.get_child_count() > 0

func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	## Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio = dialogue_label.visible_ratio
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	visible = true
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	dialogue_label.text = ""
	
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Apply any changes to the balloon given a new [DialogueLine].
func apply_dialogue_line() -> void:
	mutation_cooldown.stop()

	progress.hide()
	is_waiting_for_input = false
	dialogue_screen.focus_mode = Control.FOCUS_ALL
	dialogue_screen.grab_focus()

	character_label.visible = not dialogue_line.character.is_empty()
	character_label.text = tr(dialogue_line.character, "dialogue")
	
	var character_name = dialogue_line.character
	bg_common.visible = dialogue_line.character.is_empty()
	bg_character.visible = not dialogue_line.character.is_empty()
	if Stage.character_dict.has(character_name):
		avatar.texture = Stage.character_dict[character_name].texture_rect_avatar.texture
		avatar.visible = true
	else:
		avatar.visible = false
	
	if dialogue_screen.modulate.a != 1:
		await create_tween().tween_property(dialogue_screen, "modulate:a", 1, 0.5).finished

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	responses_menu.hide()
	responses_menu.responses = dialogue_line.responses

	# Show our balloon
	dialogue_screen.modulate.a = 1
	will_hide_dialogue_screen = false

	dialogue_label.show()
	if not dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing

	# Wait for next line
	if dialogue_line.has_tag("voice"):
		#audio_stream_player.stream = load(dialogue_line.get_tag_value("voice"))
		#audio_stream_player.play()
		#await audio_stream_player.finished
		#next(dialogue_line.next_id)
		pass
	elif dialogue_line.responses.size() > 0:
		dialogue_screen.focus_mode = Control.FOCUS_NONE
		responses_menu.show()
	elif autoplay or skip:
		if not skip:
			await get_tree().create_timer(autoplay_pause_time).timeout
		go_next()
	elif dialogue_line.time != "":
		var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)
	else:
		is_waiting_for_input = true
		dialogue_screen.focus_mode = Control.FOCUS_ALL
		dialogue_screen.grab_focus()

func go_next() -> void:
	next(dialogue_line.next_id)

## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_dialogue_screen:
		will_hide_dialogue_screen = false
		
		await create_tween().tween_property(dialogue_screen, "modulate:a", 0, 0.5).finished


func _on_mutated(_mutation: Dictionary) -> void:
	if not _mutation.is_inline:
		is_waiting_for_input = false
		will_hide_dialogue_screen = true
		mutation_cooldown.start(0.1)

func _on_dialogue_screen_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == dialogue_screen:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	for item in responses_menu.get_children():
		responses_menu.remove_child(item)
		item.queue_free()
	next(response.next_id)

#endregion
