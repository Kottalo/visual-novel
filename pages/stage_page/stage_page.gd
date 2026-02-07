class_name StagePage
extends CanvasLayer
## A basic dialogue balloon for use with Dialogue Manager.

signal next_line

@export var chapters: Array[DialogueResource]
var chapters_dict: Dictionary[String, DialogueResource]

@export var dialogue: DialogueResource

@export var autoplay_pause_time: float = 1
@export var normal_step_rate: float = 0.02
@export var skip_step_rate: float = 0.01
@export var auto_step_rate: float = 0.1

@export var dialogue_screen: Control
@export var dialogue_label: DialogueLabelEx
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
	

## The dialogue resource
var resource: DialogueResource

func get_position_by_name(position_name: String) -> Vector2:
	var position_node: Control = hbox_positions.get_node(position_name + "/CenterPoint")
	
	return position_node.global_position

var finish_pause: float = 2
var char_per_sec: float = 12
var text_progress: float:
	set(value):
		text_progress = value
		dialogue_label.visible_characters = int(text_progress)
var total_text_progress: int:
	get: return dialogue_label.text.length()

func _process(delta: float) -> void:
	if not dialogue_line: return
	
	if text_progress < total_text_progress:
		text_progress += char_per_sec * delta
		

## The current line
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			print(dialogue_line)
			process_line()

func process_line() -> void:
	dialogue_label.text = dialogue_line.text
	text_progress = 0
	while text_progress < total_text_progress:
		await get_tree().process_frame
	if autoplay:
		await get_tree().create_timer(finish_pause).timeout
	else:
		await next_line
	
	dialogue_line = await dialogue.get_next_dialogue_line(dialogue_line.next_id, [self, Stage])

func _ready() -> void:
	dialogue_label.visible_characters = 0
	for chapter in chapters:
		var chapter_name = chapter.resource_path.get_file()[0]
		chapters_dict[chapter_name] = chapter
	
	dialogue_screen.gui_input.connect(
		func (event: InputEvent):
			if event is InputEventMouseButton:
				if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					next_line.emit()
	)

func start() -> void:
	dialogue_line = await dialogue.get_next_dialogue_line("start", [self, Stage])
