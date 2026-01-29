class_name CharacterPage
extends CanvasLayer

@export var label_character_name: Label
@export var background: TextureRect
@export var character_pool: Node2D
@export var body_part_options: Array[CharacterOption]
@export var background_option: CharacterOption

var current_character: Character:
	get:
		return character_pool.get_child(Stage.character_selection_index)

var background_index: int:
	set(value):
		background_index = value
		var background_count = Stage.background_data_pool.size()
		background_index = posmod(background_index, background_count)
		var background_data = Stage.background_data_pool[background_index]
		background_option.option_name = background_data.title
		background.texture = background_data.texture

func _ready() -> void:
	Stage.character_selection_index_changed.connect(update_characters)
	
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
