class_name Game
extends Control

@export var main_dialogue: Resource
@export var hbox_positions: HBoxContainer
@export var character_image_pool: Node2D

var balloon: DialogueBalloon

#func _ready() -> void:
	#Main.game = self
	#
	#balloon = DialogueManager.show_dialogue_balloon(main_dialogue, "start", [Main])
	#
	#pass

func get_position_by_name(position_name: String) -> Vector2:
	var position_node: Control = hbox_positions.get_node(position_name + "/CenterPoint")
	
	return position_node.global_position
