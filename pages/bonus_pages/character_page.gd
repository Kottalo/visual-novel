class_name CharacterPage
extends Control

@export var label_character_name: Label
@export var background_pool: Control
@export var character_pool: Node2D
@export var body_part_options: Array[CharacterOption]
@export var background_option: CharacterOption

var current_character: Character:
	get:
		return character_pool.get_child(Main.character_selection_index)

var background_index: int:
	set(value):
		background_index = value
		var background_count = background_pool.get_child_count()
		if background_index >= background_count: background_index = 0
		if background_index < 0: background_index = background_count - 1
		background_option.option_name = \
			background_pool.get_child(background_index).name
		for background: Control in background_pool.get_children():
			background.visible = background.get_index() == background_index

func _ready() -> void:
	Main.character_selection_index_changed.connect(update_characters)
	
	background_option.previous_button.pressed.connect(
		func (): background_index -= 1
	)
	background_option.next_button.pressed.connect(
		func (): background_index += 1
	)
	background_index = 0
	
	update_characters()
	

func update_characters() -> void:
	for child: Node2D in character_pool.get_children():
		child.visible = false
	current_character.visible = true
	label_character_name.text = current_character.name
	
	for option: CharacterOption in body_part_options:
		var body_part: AnimatedSprite2D = current_character \
			.body_part_dict[option.body_part]
		var part_name = option.body_part
		Main.clear_connections(option.previous_button.pressed)
		Main.clear_connections(option.next_button.pressed)
		option.previous_button.pressed.connect(
			func ():
				current_character.update_bonus_part_index(part_name, -1)
				update_option_name(option)
		)
		option.next_button.pressed.connect(
			func ():
				current_character.update_bonus_part_index(part_name, +1)
				update_option_name(option)
		)
		update_option_name(option)

func update_option_name(option: CharacterOption) -> void:
	var part_dict = current_character.bonus_part_index_dict[option.body_part]
	option.option_name = part_dict.options[part_dict.index]
