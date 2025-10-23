extends Node

@export var character_pool: Node2D

var save_data: SaveData
var game: Game

var character_dict: Dictionary[String, Character]

func _ready() -> void:
	for character: Character in character_pool.get_children():
		character_dict[character.name] = character

#region Dialogue Commands
func Character(character_name: String) -> Character:
	return character_dict[character_name]

#endregion
