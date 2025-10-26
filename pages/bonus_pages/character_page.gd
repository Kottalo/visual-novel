class_name CharacterPage
extends Control

@export var character_pool: Node2D

var current_character: Character:
	get:
		return character_pool.get_child(Main.character_selection_index)

func _ready() -> void:
	Main.character_selection_index_changed.connect(update_characters)
	
	update_characters()

func update_characters() -> void:
	for child: Node2D in character_pool.get_children():
		child.visible = false
	current_character.visible = true
