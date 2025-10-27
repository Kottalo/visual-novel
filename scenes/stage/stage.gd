extends Node

@export var main_dialogue: Resource
@export var character_pool: Node2D
@export var stage_scene: PackedScene
@export var background_data_pool: Array[BackgroundData]

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
	DialogueManager.show_dialogue_balloon_scene(stage_scene, main_dialogue, "start", [Stage])

#region Dialogue Variables
var position_name: String
#endregion

#region Dialogue Commands
func Character(character_name: String) -> Character:
	return character_dict[character_name]
#endregion
