extends Node

@export var main_dialogue: DialogueResource
@export var character_pool: Node2D
@export var background_data_pool: Array[BackgroundData]
@export var gallery_data_pool: Array[GalleryData]

signal character_selection_index_changed
var character_selection_index: int:
	set(value):
		character_selection_index = value
		emit_signal("character_selection_index_changed")

var character_dict: Dictionary[String, Character]

func _ready() -> void:
	for character: Character in character_pool.get_children():
		character_dict[character.name] = character

func start() -> void:
	Game.hide_all_pages()
	Game.stage_page.show()
	Game.stage_page.start(main_dialogue, "start", [Stage])

#region Dialogue Variables
var position_name: String
var background_name: String
#endregion

#region Dialogue Commands
func Character(character_name: String) -> Character:
	return character_dict[character_name]

func SetBackground(background_name: String, variation_name: String,
	out_time: float = 0, in_time: float = 0) -> void:
	await create_tween().tween_property(
		Game.stage_page.texture_rect_blackscreen,
		"modulate:a",
		1,
		out_time
	).finished
	var target_background: Texture2D = background_data_pool.filter(
		func (background: BackgroundData):
			return background.title == background_name
	).front().variations[variation_name]
	Game.stage_page.texture_rect_background.texture = target_background
	await create_tween().tween_property(
		Game.stage_page.texture_rect_blackscreen,
		"modulate:a",
		0,
		in_time
	).finished

func Travel() -> void:
	Game.travel_page.visible = true
	await Game.travel_page.visibility_changed
#endregion
