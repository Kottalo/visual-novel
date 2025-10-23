extends Control

@export var main_dialogue: Resource
@export var hbox_positions: HBoxContainer

var balloon: DialogueBalloon

func _ready() -> void:
	DialogueManager.got_dialogue.connect(
		func (line: DialogueLine):
			print(line.tags)
	)
	
	balloon = DialogueManager.show_dialogue_balloon(main_dialogue, "start")
	
	pass
