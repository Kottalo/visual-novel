class_name CharacterPage
extends Control

@export var label_character_name: Label
@export var background_pool: Control
@export var character_pool: Node2D

var background_index: int:
	set(value):
		background_index = value
		for child: Control in background_pool.get_children():
			child.visible = child.get_index() == background_index

var current_character: Character:
	get:
		return character_pool.get_child(Main.character_selection_index)

func _ready() -> void:
	Main.character_selection_index_changed.connect(update_characters)
	
	update_characters()
	background_index = 0

func update_characters() -> void:
	for child: Node2D in character_pool.get_children():
		child.visible = false
	current_character.visible = true
	label_character_name.text = current_character.name
